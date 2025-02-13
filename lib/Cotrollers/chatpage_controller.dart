import 'package:chit_chat/Cotrollers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  Rx<ScrollController> scrollController = ScrollController().obs;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? chats = [];
  bool isCurrentUser = false;

  final editKey = GlobalKey<FormState>();



  getChats(
      {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot}) {
    chats = snapshot.data?.docs;
  }

  void scrollToEnd() {
    scrollController.value
        .jumpTo(scrollController.value.position.maxScrollExtent);
  }

  checkCurrentUser({required senderId, required currentUserId}) {
    if (senderId == currentUserId) {
      isCurrentUser = true;
    } else {
      isCurrentUser = false;
    }
  }
}
