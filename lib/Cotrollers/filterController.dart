import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {


  String? email;

  var allDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  var filteredDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  Rx<String> searchQuery = "".obs;
  void getData() {
    FirebaseFirestore.instance.collection("Users").snapshots().listen((snapshot) {
      allDocs.assignAll(snapshot.docs);
      filteredDocs.assignAll(allDocs);
      update();
    });
  }


  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDocs.assignAll(allDocs); // Show all if query is empty
    } else {
      filteredDocs.assignAll(
        allDocs.where((doc) =>
        doc["name"].toString().toLowerCase().contains(query.toLowerCase()) ||
            doc["email"].toString().toLowerCase().contains(query.toLowerCase())),
      );
    }
    update();
  }


  @override
  void onInit() {
    getData();
    super.onInit();
  }
}

