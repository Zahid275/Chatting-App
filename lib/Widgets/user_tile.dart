import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/user_model.dart';

class UserTile extends StatelessWidget {

  final UserModel userModel;
  void Function()? onTap;

   UserTile({super.key, required this.userModel,required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(12)
          ),

          height: MediaQuery.of(context).size.height*0.14,
          width: MediaQuery.of(context).size.width,


          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              Container(
                  height: 75,
                  width: 75,

                  child:userModel.profileImage ==""? CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Center(child: Icon(Icons.person,size: 70,color: Colors.white70,)),
                  ): CircleAvatar(
                    backgroundColor: Colors.lightBlue.shade200,
                    backgroundImage: Image.network(userModel.profileImage,fit: BoxFit.fill,).image
                   )
              ),
              const SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                      child: Text(userModel.name,style: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w700,color: Colors.white70),),
                          width:double.infinity,
                  ),


                  Text(userModel.email,style: GoogleFonts.poppins(fontSize: 13,color: Colors.black87),),
                ],
              )


            ],
          ),

        ),
      ),
    );
  }
}
