import 'package:chit_chat/Views/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'Views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetMaterialApp(
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                textSelectionTheme:TextSelectionThemeData(
                  cursorColor: Colors.blueAccent,
                  selectionColor: Colors.blueAccent,
                  selectionHandleColor: Colors.blueAccent
                )
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            );
          }
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                textSelectionTheme:TextSelectionThemeData(
                    cursorColor: Colors.blueAccent,
                    selectionColor: Colors.blueAccent,
                    selectionHandleColor: Colors.blueAccent
                )
            ),
            home: AuthScreen(),
          );
        });
  }
}
