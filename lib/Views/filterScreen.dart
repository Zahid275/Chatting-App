import 'package:chit_chat/Cotrollers/filterController.dart';
import 'package:chit_chat/Models/user_model.dart';
import 'package:chit_chat/Views/chat_screen.dart';
import 'package:chit_chat/Widgets/search_field.dart';
import 'package:chit_chat/Widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  FilterController filterController = Get.put(FilterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Filter Users",
          style: GoogleFonts.poppins(
              fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: GetBuilder<FilterController>(builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: SearchField(
                  onChanged: (value) {
                    filterController.searchUsers(value.toString());
                  },
                  label: "Search Users",
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: filterController.filteredDocs.length,
                    itemBuilder: (context, index) {
                      print(filterController.filteredDocs.length);
                      final data = filterController.filteredDocs[index];

                      String urId = FirebaseAuth.instance.currentUser!.uid;
                      List chatId = [data["userId"], urId];
                      chatId.sort();

                      UserModel userModel = UserModel(
                        userToken: data["deviceToken"],
                        profileImage: data["profileImage"],
                        isOnline: data["isOnline"],
                        name: data["name"],
                        email: data["email"],
                        chatId: chatId.join(),
                        userId: data["userId"],
                      );
                      return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          child: UserTile(
                            userModel: userModel,
                            onTap: () {
                              Get.to(ChatScreen(
                                userModel: userModel,
                              ));
                            },
                          ));

                      // return UserTile(userObject: userObject, onTap: (){})
                    }),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        }),
      ),
    );
  }
}
