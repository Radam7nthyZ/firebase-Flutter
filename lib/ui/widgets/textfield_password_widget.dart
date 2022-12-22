import 'package:flutter/material.dart';

import '../general/colors.dart';

class TextFieldPasswordWidget extends StatefulWidget {
  TextEditingController controller;
  TextFieldPasswordWidget({required this.controller});

  @override
  State<TextFieldPasswordWidget> createState() =>
      _TextFieldPasswordWidgetState();
}

class _TextFieldPasswordWidgetState extends State<TextFieldPasswordWidget> {
  bool isInvisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isInvisible,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        prefixIcon: Icon(
          Icons.lock,
          size: 20.0,
          color: KBrandPrimaryColor,
        ),
        suffix: IconButton(
          icon: Icon(
            isInvisible ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            color: KBrandPrimaryColor.withOpacity(0.6),
          ),
          onPressed: () {
            isInvisible = !isInvisible;
            setState(() {});
          },
        ),
        hintText: "Contraseña",
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: KBrandPrimaryColor.withOpacity(0.6),
        ),
        filled: true,
        fillColor: KBrandSecondaryColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String? value) {
        if (value != null && value.isEmpty) {
          return "Campo obligatorio";
        }
        return null;
      },
    );
    ;
  }
}
