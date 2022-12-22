import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase/pages/homepage.dart';
import 'package:firebase/services/my_service_firestore.dart';

import '../ui/general/colors.dart';
import '../ui/widgets/button_custom_widget.dart';
import '../ui/widgets/general_widgets.dart';
import '../ui/widgets/textFlied_normal_widget.dart';
import '../ui/widgets/textfield_password_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final keyForm = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _fullNamecontroller = TextEditingController();
  MyServiceFirestore userService = MyServiceFirestore(collection: "users");

  _registerUser() async {
    try {
      if (keyForm.currentState!.validate()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text,
          password: _passwordcontroller.text,
        );
        if (userCredential.user != null) {
          UserModel userModel = UserModel(
            fullName: _fullNamecontroller.text,
            email: _emailcontroller.text,
          );
          userService.addUser(userModel).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "weak-password") {
        showSnackBarError(context, "La contraseña es muy debil");
      } else if (error.code == "email-already-in-use") {
        showSnackBarError(context, "El correo electronico ya está en uso");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                divider40(),
                SvgPicture.asset(
                  'assets/images/register.svg',
                  height: 180.0,
                ),
                divider30(),
                Text(
                  "Registrate",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: KBrandPrimaryColor,
                  ),
                ),
                divider10(),
                TextFieldNormalWidget(
                  hintText: "Nombre Completo",
                  icon: Icons.email,
                  controller: _fullNamecontroller,
                ),
                divider10(),
                TextFieldNormalWidget(
                  hintText: "Correo electrónico",
                  icon: Icons.email,
                  controller: _emailcontroller,
                ),
                divider6(),
                TextFieldPasswordWidget(
                  controller: _passwordcontroller,
                ),
                divider20(),
                ButtonCustonWidget(
                  text: "Registrate",
                  icon: "check",
                  color: KBrandPrimaryColor,
                  onPressed: () {
                    _registerUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
