import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,

        centerTitle: true,
        title: Text(
          "About Chit Chat",
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w500,color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Welcome to my chatting application, built with Flutter and powered by Firebase Firestore, Firebase Authentication and Firebase Storage.",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "I, Zahid Rasheed,developed this app to sharpen my Flutter development skills and explore real-time messaging solutions.",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Key Features : ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              Text(
                """     
✅ Cloud-Based Storage – Efficient media handling with Cloudinary.
✅ Real-Time Sync – Messages update instantly using Firestore.,
✅ Instant Notifications – Stay updated with Firebase Cloud Messaging.,

This project reflects my passion for Flutter development. Hope you find it useful! 🚀
          
              
              """,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
