import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cotrollers/home_controller.dart';
import '../Views/about_screen.dart';
import '../Views/account_screen.dart';

Widget customDrawer({required context,required HomeController homeController}){
  return Drawer(
    backgroundColor: Colors.blue.shade200,
    child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
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
                      color: Colors.blueAccent,
                    ),
                  );
                } else {
                  homeController.getMyData(snapshot: snapshot);
                  var data = homeController.myData;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: data!["profileImage"]== ""? CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Icon(
                                FontAwesomeIcons.solidCircleUser,
                                color: Colors.white70,
                                size: 120,
                              ),
                            ):CircleAvatar(
                              backgroundImage: Image.network("${data["profileImage"]}").image,
                            ),
                          )),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            data["name"],
                            style: GoogleFonts.roboto(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            data["email"],
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
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
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            Get.to(AccountPage());
          },
          child: const ListTile(
            leading: Icon(FontAwesomeIcons.solidUser, size: 27),
            title: Text("Account", style: TextStyle(fontSize: 21)),
          ),
        ),
        const SizedBox(height: 20),
        const ListTile(
          leading: Icon(FontAwesomeIcons.gear, size: 27),
          title: Text("Settings", style: TextStyle(fontSize: 21)),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: (){
            Get.to(AboutPage());
          },
          child: const ListTile(
            leading: Icon(FontAwesomeIcons.circleInfo, size: 27),
            title: Text("About", style: TextStyle(fontSize: 21)),
          ),
        ),
        Expanded(child: Container()),
        const Divider(),
        InkWell(
          onTap: ()async{
            await homeController.setOffline();
            FirebaseAuth.instance.signOut();
            homeController.friends.clear();
            homeController.filteredFriends.clear();
          },
          child: const Row(
            children: [
              Icon(Icons.logout, size: 28),
              SizedBox(width: 10),
              Text("Sign out", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
      ],
    ),
  );
}