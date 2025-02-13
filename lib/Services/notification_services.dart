import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  void listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New Toke $newToken");
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional Permission Granted");
    } else {
      print("Permission Denied");
    }
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings androidInitializeSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializeSetting =
        DarwinInitializationSettings();

    const InitializationSettings initializeSetting = InitializationSettings(
      android: androidInitializeSetting,
      iOS: iosInitializeSetting,
    );

    await flutterLocalNotificationPlugin.initialize(initializeSetting,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
    });

    firebaseInit();
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      print("Message body: ${message.notification?.body}");

      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when the app is opened from a terminated state
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "Notification_Channel",
      importance: Importance.max,
    );

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "Notification from Chit Chat App",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("Users").doc(userId).update({
        "deviceToken": newToken, // Update token when refreshed
      });
    });
    return token;
  }

  String apiKey = "";

  getApiKey() async {
    final json = {
      "type": "service_account",
      "project_id": "chat-system-d4a1e",
      "private_key_id": "ecd43f961c2d3cd80d1541d8ab0627e2c280379b",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDDjJH3zX+uLzbK\nMwETOlFtXfSN5qDWOlDXsmY9aN25k49l8f1Bz0NRG+RGCn9fPmgC4zlx2Ibrk4PF\nxNJNiX8lDpRPav8qWHUPX3vDyyksQUbEygLcYg5feMi3tCHSTJU4sUtO87dA3HOo\nOBkE1WsoN2qzJiK9qsQiNfaFUtNh++NgJBDtKX/y1FE6741dpeq7ChU2ZJSQQpd5\nidQNR5CBr+yT7wBC2jzVxjqspSD7rKZ/gPe5zQ7dtawt4/N31hOTf+EOFqUP18Do\nInwaFOoeI5Lw8vhpl4nRzNnw2MXwc2f+IqEKIdDk0yuQwARf67X8Vv4Fe86YM9sW\nQYAjly5NAgMBAAECggEAGNcRb739+x1qQ1MpTsz4rQDjYOcsBSqRPGUgEarxh3JU\nI+oSdrqiXXpCjBcnSOz/f2Zn1KthsCkj8wpmgIz3xrhMZK49zZ5A+Hvzl9KF32ZH\nXBYhOOeH1d7c+GD8bt9lkTcMTvIslCOs2XCO1QtbOleXyTwN67P2iDX8o8D6sxZ4\nECUYv0KAGeVgaHbQwG2M3FfTgpxewgUjx80OvPCEQQ5qrIfJlhZBTBTmwIgLK96S\nAoXzkmrFuBPO8tOIID69093tf1YTfmsKORM9tmOVQZRXZUcIzvdr3wjmh5WL2jja\nlzU9H7dRtxUNLkgJrzF9h+aE9PbMFu0BatY1GDk6LQKBgQD3kK4NKRV4vS05Zg2h\ns4QaF0Xwe0xcuCbPaSt4+q+euZKcM+b8+z17GizcFP2d7t7IZFJm4YwkB/aHCfEj\njLgM/ErdmmgGOOwjRvKuho1CbVFIa1VknAtmVWnbgJXn0VO6G7Um7GvYDZ1Gzowt\nuk/dJsLO7br6lbTX7fr9QbgJywKBgQDKNjHAWW1RNuYXj0lj5Hzb7bNbq0L7KTOO\n1q9l7YATb6ebvzDQwpbm/gudGGn9Ihd1NmXCri0MU788jZAC8NdL+fSMeBezdUU0\nJqlWJtkAbrBfsK8iJesCee8D9XC7/tBROwabBU/V5T1zP1IRSA9DV8ame6uEKJfo\n7ol9DqKFRwKBgBfUESyrG6n3a3bu37kEsl5ghxbSh1MVVob4NHr8hhLdAcOPK1iG\nRjCnIFI+ovqkl0TqgxPr+bUuHwh4aIFndf+p+PrDdefDatcqaQlrYgVWyFAUJK/+\nZQqAhiPeiI87kreDGziX4Pl2tgCuuMdd+3np1S5dq3WbG0D9Yv8laDVpAoGAGUnV\nxvxoE3QOKnwc7YUxqD994sT0R3zLmd13agPdtJCOIYgzjqgHPzQeN7NJ7gJJdLss\n1r/5mkUO8X+ytutvwWytDLQoIqVT1kXPf5q0IL23CQCLpnWfglvFbHVRd/FSFBaR\nqOltJo7YtIUCum6MmhtsGH324TxCYzsRrrYZ1RkCgYAPzTpfL8ndascMHDxwBnXS\nfKs3+eygMV43+oNPDyiTHCZgSePRh7Utr71hlU+MfH/+Zz2qigFVzVfbswHsN6QM\nb+YkZnPtF5nbeeYDzZCFABdFwQ731ViQmriPH/1xtvXaTFWJZNHsDTSe8xRT0s71\nzB+07D8JLehvGLqaX9okqQ==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@chat-system-d4a1e.iam.gserviceaccount.com",
      "client_id": "110583678208293468138",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40chat-system-d4a1e.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    final credentials = auth.ServiceAccountCredentials.fromJson(json);

    final scopes = [
      "https://www.googleapis.com/auth/firebase",
      "https://www.googleapis.com/auth/cloud-platform",
    ];

    final client = await auth.clientViaServiceAccount(credentials, scopes);

    final key = client.credentials.accessToken.data;

    apiKey = key.toString();
  }

  sendNotification(
      {required String title,
      required String body,
      required receiverToken}) async {
    await getApiKey();

    String url =
        "https://fcm.googleapis.com/v1/projects/chat-system-d4a1e/messages:send";
    final uri = Uri.parse(url);

    final response = await http.post(uri,
        body: jsonEncode({
          "message": {
            "token": receiverToken,
            "notification": {"body": body, "title": title}
          }
        }),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $apiKey"
        });

    if (response.statusCode == 200) {
      print("No errors");
    } else {
      print(response.body);
    }
  }
}
