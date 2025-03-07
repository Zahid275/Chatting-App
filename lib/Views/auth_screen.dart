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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill)),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.39),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    authController.isSignUp.value ? "Sign Up" : "Sign In",
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: Form(
                    key: authController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (authController.isSignUp.value)
                          AuthField(
                            onSaved: (value) {
                              authController.name = value;
                            },
                            validator: (value) => value!.isEmpty
                                ? "Please enter full name"
                                : null,
                            label: "Full Name",
                          ),
                        AuthField(
                          onSaved: (value) {
                            authController.email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) return "Please Enter Email";
                            if (!value.contains("@")) return "Invalid Email";
                            return null;
                          },
                          label: "Email",
                        ),
                        AuthField(
                          onSaved: (value) {
                            authController.password = value;
                          },
                          validator: (value) => value!.length < 6
                              ? "Password must be at least 6 characters"
                              : null,
                          label: "Password",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: authController.toggleSignUp,
                              child: Text(
                                authController.isSignUp.value
                                    ? "Already a member? Sign in"
                                    : "New here? Register",
                                style: TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forget Password",
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: size.width * 0.05),
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: size.height * 0.061,
                      width: size.width * 0.3,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white70, width: 1.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          if (authController.formKey.currentState!.validate()) {
                            authController.formKey.currentState!.save();
                            authController.isSignUp.value
                                ? authServices.signUp(
                                name: authController.name.toString(),
                                email: authController.email.toString().trim(),
                                password: authController.password.toString().trim())
                                : authServices.signIn(
                                email: authController.email.toString().trim(),
                                password: authController.password.toString().trim());
                          }
                        },
                        child: Text(
                          authController.isSignUp.value ? "Sign Up" : "Sign In",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                if (authController.isLoading.value)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  ),
                SizedBox(height: size.height * 0.05),
              ],
            );
          }),
        ),
      ),
    );
  }
}
