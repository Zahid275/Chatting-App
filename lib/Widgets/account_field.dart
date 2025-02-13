import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountField extends StatelessWidget {
  final String label;
  final String text;
  final IconData iconData;
  final String? Function(String?)? onValidate;
   bool? enabled=true;

  final void Function(String?)? onSaved;
   AccountField({ enabled,super.key, required this.text, required this.label,required this.iconData,required this.onSaved,required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08,),
      child: SizedBox(
        child: TextFormField(
          enabled: enabled,
          initialValue: text,
          validator: (value){
           return onValidate!(value);
          },
          cursorColor: Colors.blueAccent,
          style: GoogleFonts.poppins(fontSize: 15,),
          onSaved: (value){
            return onSaved!(value);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 23.0),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 20.0,left: 30),
              child: Icon(iconData,color: Colors.white70,size: 30,),
            ),
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Colors.white)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Colors.blueAccent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Colors.blueAccent)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Colors.blueAccent)),
          ),
        ),
      ),
    );
  }
}
