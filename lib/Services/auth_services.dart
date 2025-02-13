import 'package:chit_chat/Cotrollers/auth_controller.dart';
import 'package:chit_chat/Models/user_model.dart';
import 'package:chit_chat/Services/db_services.dart';
import 'package:chit_chat/Services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthServices {


  final notificationServices  =NotificationServices();

  AuthController authController = Get.put(AuthController());
  DbServices dbServices = DbServices();

  signIn({required String email,required String password})async {

    try{
      authController.isLoading.value= true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.toString(), password: password);

      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 3),
        messageText: Text("Successfully Signed in",style: TextStyle(color: Colors.white70),),));
      authController.isLoading.value= false;
    }on FirebaseAuthException catch (e){
    authController.isLoading.value = false;

    Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),

        messageText: Text("Error: ${e.code}",style: const TextStyle(color: Colors.white),),));
    }
  }
  signUp({required String  name,required String email,required String password,})async {

    try {
      authController.isLoading.value= true;

      String? token;
       notificationServices.getDeviceToken().then((value){
         token = value;
       });

     final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      String? deviceToken = await notificationServices.getDeviceToken();

     UserModel userModel = UserModel(
         userToken: deviceToken,
         profileImage: "", isOnline: false, name: name, email: credentials.user!.email,  userId: credentials.user!.uid);


     await dbServices.createUser(userModel: userModel,password: password);
     // await dbServices.createUser(name: name, email:credentials.user!.email.toString(), userId: credentials.user!.uid,deviceToken: token.toString(),password: password);
      authController.isLoading.value = false;

     Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 3),
        messageText: Text("Successfully signed up",style: TextStyle(color: Colors.white70),),));

    }catch(e){
      authController.isLoading.value = false;

      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),

        messageText: Text("Error $e",style: const TextStyle(color: Colors.white),),));    }
  }







  //SignUp Function
}