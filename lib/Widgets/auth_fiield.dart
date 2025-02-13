import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthField extends StatelessWidget {
  final String? label;
  final void Function(String?)? onSaved;
  final Function(String?)? validator;


 const AuthField({super.key, required this.label,required this.onSaved,required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label",
            style: GoogleFonts.poppins(
                fontSize: 14, color: Colors.blue)),
         TextFormField(
     cursorColor: Colors.blue,
     decoration: InputDecoration(
       border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(color: Colors.blue, width: 1.5),
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(color: Colors.blue, width: 1.5),
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(color: Colors.blue, width: 1.5),
         ),
         disabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(15),
           borderSide: const BorderSide(color: Colors.blue, width: 1.5),
         )),
     onSaved: (value) {
       return onSaved!(value);
     },
     validator: (value) {
       return validator!(value.toString());
     }

         ),]);
  }
}
