import 'package:chit_chat/Cotrollers/home_controller.dart';
import 'package:chit_chat/Models/user_model.dart';
import 'package:chit_chat/Services/notification_services.dart';
import 'package:chit_chat/Views/chat_screen.dart';
import 'package:chit_chat/Views/filterScreen.dart';
import 'package:chit_chat/Widgets/custom_drawer.dart';
import 'package:chit_chat/Widgets/search_field.dart';
import 'package:chit_chat/Widgets/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController =
      Get.put(HomeController()); // Retrieve instance

  NotificationServices notificationServices = NotificationServices();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context: context, homeController: homeController),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
        child: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.blue.shade300,
            onPressed: () {
              Get.to(FilterScreen());
            },
            child: const Icon(
              Icons.edit,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Chit Chat",
          style: GoogleFonts.poppins(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Container(
        padding:EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02,horizontal: MediaQuery.of(context).size.width * 0.04,),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
                child: SearchField(
              onChanged: (value) {
                homeController.searchUsers(value.toString());
              },
              label: "Search friends",
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection("Friends")
                  .snapshots(),
              builder: (context, snapshot) {
                homeController.getDocs(snapshot);

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something Went Wrong"),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                } else {

                    return Obx(() {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: homeController.filteredFriends.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot<
                                  Map<String, dynamic>>? data =
                              homeController.filteredFriends[index];

                              String urId = FirebaseAuth.instance.currentUser!
                                  .uid;
                              List chatId = [data["userId"], urId];
                              chatId.sort();

                              final userInfo = UserModel(
                                  userToken: data["deviceToken"],
                                  profileImage: data["profileImage"],
                                  isOnline: data["isOnline"],
                                  chatId: chatId.join(),
                                  userId: data["userId"],
                                  name: data["name"],
                                  email: data["email"]);

                              return Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,),
                                child: UserTile(
                                  userModel: userInfo,
                                  onTap: () {
                                    Get.to(ChatScreen(
                                      userModel: userInfo,
                                    ));
                                  },
                                ),
                              );
                            }

                        ),
                      );
                      });
                  }

              },
            ),
          ],
        ),
      ),
    );
  }
}
