import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel userModel;
  void Function()? onTap;

  UserTile({super.key, required this.userModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(12)),
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.029,
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.18,
                width: MediaQuery.of(context).size.width * 0.18,
                child: userModel.profileImage.isEmpty
                    ? CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person,
                            size: MediaQuery.of(context).size.width * 0.15,
                            color: Colors.white70),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.lightBlue.shade200,
                        backgroundImage: NetworkImage(userModel.profileImage),
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.029,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.name,
                    style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70),
                  ),
                  Text(
                    userModel.email,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.black87),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
