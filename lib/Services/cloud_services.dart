import 'dart:io';
import 'package:chit_chat/Cotrollers/auth_controller.dart';
import 'package:chit_chat/Services/db_services.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CloudServices {

  final authController  = Get.put(AuthController);
  final cloudinary = Cloudinary.signedConfig(
    apiKey: "151892799529124",
    apiSecret: "fEhzX4aHYeMIkcbmA9zuMwDd584",
    cloudName: "dz6supklb",
  );



DbServices dbServices =DbServices();


//Function to upload image to cloudinary
  uploadImage({required File image})async {
    final response = await
    cloudinary.upload
      (
        file: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: "Profile Pictures",
        fileName: '${FirebaseAuth.instance.currentUser!.email }dp',
        progressCallback: (count, total) {
          print(
              'Uploading image from file with progress: $count/$total');
        });


    if(response.isSuccessful) {
    try{
      await dbServices.addUserImage(imageUrl: response.secureUrl.toString(),
          userId: FirebaseAuth.instance.currentUser!.uid.toString());
      print("Successfully added imageUrl to Firestore DB Image Url:${response.secureUrl}");
    }catch(e){
      print("Error in adding image to Firestore $e");
    }}else{
      print("Error in adding image to cloud ");
    }
  }}