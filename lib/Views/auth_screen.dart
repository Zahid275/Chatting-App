import 'package:chit_chat/Cotrollers/auth_controller.dart';
import 'package:chit_chat/Services/auth_services.dart';
import 'package:chit_chat/Widgets/auth_fiield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  AuthServices authServices = AuthServices();
  AuthController authController = Get.put(AuthController());

  AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,

          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill)),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.395),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: authController.isSignUp.value
                        ? Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )
                        : Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08),
                  child: Form(
                    key: authController.formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authController.isSignUp.value
                              ? AuthField(
                                  onSaved: (value) {
                                    authController.name = value;
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return "Please enter full name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: "Full Name")
                              : const SizedBox(),
                          AuthField(
                              onSaved: (value) {
                                authController.email = value;
                              },
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "Please Enter Email";
                                } else if (!(value.toString().contains("@"))) {
                                  return "Invalid Email";
                                } else {
                                  return null;
                                }
                              },
                              label: "Email"),
                          Column(
                            children: [
                              AuthField(
                                  onSaved: (value) {
                                    authController.password = value;
                                  },
                                  validator: (value) {
                                    if (value.toString().length < 6) {
                                      return "Password must be of atleast 6 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: "Password"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        authController.toggleSignUp();
                                      },
                                      child: authController.isSignUp.value
                                          ? const Text(
                                              "Already member! Sign in",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue),
                                            )
                                          : const Text("New here? Register",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue))),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forget Password",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ]),
                  ),
                ),

                Expanded(
                  child: Container(
                    padding:  EdgeInsets.only(right: 20),
                    alignment: Alignment.bottomRight,
                    height: MediaQuery.of(context).size.height,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.061,
                      width: MediaQuery.of(context).size.width*0.3,

                      child: TextButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white70, width: 1.2),
                                borderRadius: BorderRadius.circular(7)),
                          ),
                          onPressed: () {
                            if (authController.formKey.currentState!.validate()) {
                              authController.formKey.currentState!.save();
                  
                              authController.isSignUp.value
                                  ? authServices.signUp(
                                      name: authController.name.toString(),
                                      email:
                                          authController.email.toString().trim(),
                                      password: authController.password
                                          .toString()
                                          .trim())
                                  : authServices.signIn(
                                      email:
                                          authController.email.toString().trim(),
                                      password: authController.password
                                          .toString()
                                          .trim());
                            }
                          },
                          child: authController.isSignUp.value
                              ? Text(
                                  "Sign Up ",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 20),
                                )
                              : Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 20),
                                )),
                    ),
                  ),
                ),

             authController.isLoading.value ==true  ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                ):SizedBox(),

                SizedBox(height: MediaQuery.of(context).size.height*0.05,)
              ],
            );
          }),
        ),
      ),
    );
  }
}
