import 'dart:io';
import 'package:chit_chat/Services/cloud_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountController {
  final formKey = GlobalKey<FormState>();

  CloudServices cloudServices = CloudServices();
  File? image;
  RxBool isLoading = false.obs;

  String? name;
  String? email;
  String?  password;

  final ImagePicker _picker = ImagePicker();

  String? imageUrl;

  pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {

      image = File(pickedFile.path);
      isLoading.value =true;

      await cloudServices.uploadImage(image: image!);
      isLoading.value =false;
    }
  }
}
