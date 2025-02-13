import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageField extends StatelessWidget {
  TextEditingController textMessage;
  void Function()? onSend;

  MessageField({super.key, required this.textMessage,required this.onSend});
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                cursorColor: Colors.blueAccent,
                cursorErrorColor: Colors.blueAccent,

                controller: textMessage,
                decoration: InputDecoration(
                    hintText: "Enter Message",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none
                    )
                ),

              ),
            ),
          ),
         Padding(
           padding: const EdgeInsets.only(right:  3.0),
           child: SizedBox(
             height: 55,
             width: 55,
             child: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: IconButton(onPressed: onSend, icon:const Icon(FontAwesomeIcons.paperPlane,size: 22,color: Colors.white,))
                     ),
           ),
         )



        ],
      ),
    );
  }
}
