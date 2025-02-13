import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  var isOnline = true.obs;
  var searchQuery = "".obs;

  Map<String,dynamic>? myData;
  var friends = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  var filteredFriends = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  void getDocs(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
      friends.assignAll(snapshot.data!.docs);
      filteredFriends.assignAll(friends);
    }
  }




  getMyData({required AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot}){
   myData= snapshot.data!.data() as Map<String, dynamic>;

  }

  Future<void> setOnline() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": true});
      isOnline.value = true;
    } catch (e) {
      print("Error setting online: $e");
    }
  }






  getMyDocs(){

  }

  Future<void> setOffline() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": false});
      isOnline.value = false;
    } catch (e) {
      print("Error setting offline: $e");
    }
  }
  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredFriends.assignAll(friends); // Show all if query is empty
    } else {
      filteredFriends.assignAll(
        friends
            .where((doc) {
          var data = doc.data();
          return (data["name"]?.toString().toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (data["email"]?.toString().toLowerCase().contains(query.toLowerCase()) ?? false);
        })
            .toList(), // Convert to list
      );
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    setOnline();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    setOffline();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setOnline();
    } else {
      setOffline();
    }
  }
}
