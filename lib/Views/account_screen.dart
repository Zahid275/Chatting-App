import 'package:chit_chat/Cotrollers/account_controller.dart';
import 'package:chit_chat/Widgets/account_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatelessWidget {
  AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade200,
          centerTitle: true,
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
                fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.currentUser != null
                ? FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots()
                : null, // If user is null, no stream
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                Map<String, dynamic>? data = snapshot.data!.data();
                return Form(
                    key: accountController.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(children: [
                              SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: data!["profileImage"] == ""
                                      ? CircleAvatar(
                                          backgroundColor: Colors.blueGrey,
                                          child: Icon(
                                            FontAwesomeIcons.solidCircleUser,
                                            color: Colors.white70,
                                            size: 180,
                                          ))
                                      : CircleAvatar(
                                          backgroundColor: Colors.blueGrey,
                                          backgroundImage: NetworkImage(
                                            data["profileImage"],
                                          ))),
                              Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.01,
                                  right:
                                      MediaQuery.of(context).size.width * 0.01,
                                  child: InkWell(
                                      onTap: () async {
                                        await accountController.pickImage();
                                        print(accountController.imageUrl);
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                      )))
                            ]),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          AccountField(
                            onSaved: (value) {
                              accountController.name = value;
                            },
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter new name ";
                              }
                            },
                            iconData: FontAwesomeIcons.user,
                            label: "Full Name",
                            text: "${data["name"]}",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          AccountField(
                            enabled: false,
                            onSaved: (value) {
                              accountController.email = value;
                            },
                            onValidate: (value) {
                              if (value.toString().isEmpty ||
                                  !(value.toString().contains("@"))) {
                                return "Please enter valid email addresss ";
                              }
                            },
                            iconData: Icons.email_outlined,
                            label: "Email",
                            text: "${data["email"]}",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          AccountField(
                            onSaved: (value) {
                              accountController.password = value;
                            },
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter new password ";
                              }
                            },
                            iconData: Icons.lock_outline,
                            label: "Password",
                            text: "${data["password"]}",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () async {
                                  {
                                    if (accountController.formKey.currentState!
                                        .validate()) {
                                      accountController.formKey.currentState!
                                          .save();
                                      if (accountController.name !=
                                              data["name"] ||
                                          accountController.email !=
                                              data["email"] ||
                                          accountController.password !=
                                              data["password"]) {
                                        try {
                                          User? user =
                                              FirebaseAuth.instance.currentUser;

                                          if (user != null) {
                                            try {
                                              AuthCredential credential =
                                                  EmailAuthProvider.credential(
                                                email: "${data["email"]}",
                                                password: "${data["password"]}",
                                              );

                                              // Re-authenticate the user
                                              await user
                                                  .reauthenticateWithCredential(
                                                      credential);

                                              //  user.emailVerified;
                                              // await user.verifyBeforeUpdateEmail("${accountController.email}");
                                              await user.updatePassword(
                                                  "${accountController.password}");

                                              print(
                                                  "Successfully Updated Profile");
                                              GetSnackBar(
                                                  message:
                                                      "Successfully Updated Profile");
                                            } on FirebaseAuthException catch (e) {
                                              print("Error: ${e.message}");
                                            }
                                          }

                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(user!.uid)
                                              .update({
                                            "name":
                                                accountController.name!.trim(),
                                            "password": accountController
                                                .password!
                                                .trim()
                                          });
                                          print("Successfully Updated Profile");

                                          Get.snackbar("", "Successfully updated Credentials",snackPosition: SnackPosition.BOTTOM);
                                        } on FirebaseAuthException catch (e) {
                                          Get.showSnackbar(GetSnackBar(
                                            duration: Duration(seconds: 2),
                                            messageText: Text(
                                                "Error: ${e.message}",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ));
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                )),
                          ),
                          Obx(() {
                            if (accountController.isLoading == true) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          })
                        ],
                      ),
                    ));
              }
            }));
  }
}
