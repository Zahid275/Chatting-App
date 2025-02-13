import 'package:chit_chat/Services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  NotificationServices notificationServices = NotificationServices();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    notificationServices.requestNotificationPermission();
    notificationServices.initLocalNotification();
    notificationServices.listenForTokenRefresh();

  }
  String? name;
  String? email;
  String? password;
  String? confirmPass;
  Rx<bool> isSignUp = false.obs;
  Rx<bool> isLoading = false.obs;





  final formKey = GlobalKey<FormState>();


  toggleSignUp(){
    isSignUp.value =!isSignUp.value;
  }




}