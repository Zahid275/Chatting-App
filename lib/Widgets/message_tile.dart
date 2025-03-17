import 'package:auto_size_text/auto_size_text.dart';
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
                   padding: EdgeInsets.all(12),
                   decoration: BoxDecoration(
                       color: isCurrentUser ? Colors
                           .lightBlue : Colors.white,
                       borderRadius:  isCurrentUser? const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)
                       ): const BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                   ),
                     child: Column(
                       children: [
                         ConstrainedBox(
                           constraints: BoxConstraints(
                             maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust width
                           ),
                           child: Text(
                             "$message",
                             style: GoogleFonts.poppins(
                               fontSize: 18,
                               color: isCurrentUser ? Colors.white : Colors.black,
                             ),
                             maxLines: null,
                             overflow: TextOverflow.visible,
                           ),
                         )
                       ],
                     ),
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
