import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cotrollers/home_controller.dart';
import '../Views/about_screen.dart';
import '../Views/account_screen.dart';

Widget customDrawer({required context, required HomeController homeController}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  return Drawer(
    backgroundColor: Colors.blue.shade200,
    child: Column(
      children: [
        SizedBox(
          height: screenHeight * 0.366,
          child: DrawerHeader(

            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  homeController.getMyData(snapshot: snapshot);
                  var data = homeController.myData;
                  return Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Center(
                        child: SizedBox(
                          height: screenWidth * 0.3,
                          width: screenWidth * 0.3,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            backgroundImage: data!["profileImage"] != ""
                                ? NetworkImage("${data["profileImage"]}")
                                : null,
                            child: data["profileImage"] == ""
                                ? Icon(
                              FontAwesomeIcons.solidCircleUser,
                              color: Colors.white70,
                              size: screenWidth * 0.3,
                            )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.007),
                      Column(
                        children: [
                          Text(
                            data["name"],
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            data["email"],
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        InkWell(
          onTap: () {
            Get.to(AccountPage());
          },
          child: ListTile(
            leading: Icon(FontAwesomeIcons.solidUser, size: screenWidth * 0.07),
            title: Text("Account", style: TextStyle(fontSize: screenWidth * 0.05)),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        ListTile(
          leading: Icon(FontAwesomeIcons.gear, size: screenWidth * 0.07),
          title: Text("Settings", style: TextStyle(fontSize: screenWidth * 0.05)),
        ),
        SizedBox(height: screenHeight * 0.02),
        InkWell(
          onTap: () {
            Get.to(AboutPage());
          },
          child: ListTile(
            leading: Icon(FontAwesomeIcons.circleInfo, size: screenWidth * 0.07),
            title: Text("About", style: TextStyle(fontSize: screenWidth * 0.05)),
          ),
        ),
        Expanded(child: Container()),
        const Divider(),
        InkWell(
          onTap: () async {
            await homeController.setOffline();
            FirebaseAuth.instance.signOut();
            homeController.friends.clear();
            homeController.filteredFriends.clear();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: screenWidth * 0.07),
              SizedBox(width: screenWidth * 0.03),
              Text("Sign out", style: TextStyle(fontSize: screenWidth * 0.045)),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
      ],
    ),
  );
}
