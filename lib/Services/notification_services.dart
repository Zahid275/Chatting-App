import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
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

    final serviceAccount = await rootBundle.loadString('Service_Credentials.json');
    final credentials = auth.ServiceAccountCredentials.fromJson(jsonDecode(serviceAccount));

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
