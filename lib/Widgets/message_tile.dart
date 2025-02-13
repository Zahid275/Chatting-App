import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageTile extends StatelessWidget {

  final message;
  bool isCurrentUser;
  String status;
  final void Function() onLongPress;


  MessageTile({required this.onLongPress,required this.status,super.key, required this.message,required this.isCurrentUser});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      child: Container(
        child: Row(
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end:MainAxisAlignment.start,
            children: [
              Column(
                children: [

                 Container(
                   padding: const EdgeInsets.all(10),
                   height: MediaQuery.of(context).size.height*0.05,
                   decoration: BoxDecoration(
                       color: isCurrentUser ? Colors
                           .lightBlue : Colors.white,
                       borderRadius:  isCurrentUser? const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)
                       ): const BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                   ),
                     child: Center(child: Text("$message",style: GoogleFonts.poppins(fontSize: 18,color: isCurrentUser? Colors.white:Colors.black),)),
                 ),
                  isCurrentUser ?  Text( status,style: const TextStyle(color: Colors.blueGrey),):const SizedBox()



                ],
              ),
            ],

        ),
      ),
    );
  }
}
