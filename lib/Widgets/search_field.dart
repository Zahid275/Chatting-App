import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatelessWidget {
  String label;
  final Function(String?)? onChanged;
   SearchField({required this.onChanged,required this.label});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
            )
          ]),
      child: Row(
        children: [SizedBox(
            height:60,
            width: 60,
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
            )),
          SizedBox(
            width: 200,
            child: TextField(

              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value.toString());
                }
              },

              decoration: InputDecoration(
                  hintText: "$label",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  )
              ),

            ),
          )

        ],
      ),
    );
  }
}
