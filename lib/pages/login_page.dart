import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase/pages/homepage.dart';
import 'package:firebase/pages/register_pages.dart';
import 'package:firebase/ui/general/colors.dart';
import 'package:firebase/ui/widgets/button_custom_widget.dart';
import 'package:firebase/ui/widgets/button_normal_widget.dart';
import 'package:firebase/ui/widgets/general_widgets.dart';
import 'package:firebase/ui/widgets/textFlied_normal_widget.dart';
import 'package:firebase/ui/widgets/textfield_password_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  _login() async {
    try {
      if (formKey.currentState!.validate()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text,
          password: _passwordcontroller.text,
        );
        if (userCredential.user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        showSnackBarError(context, "El correo electronico es invalido");
      } else if (error.code == "user-not-found") {
        showSnackBarError(context, "El usuario no esta registrado");
      } else if (error.code == "wrong-password") {
        showSnackBarError(context, "La contraseña es incorrecta");
      }
    }
  }

  _loginWithGoogle() {
    showSnackBarError(
        context, "Este servicio esta deshabilitado temporalmente");
  }

  _loginWithFacebook() {
    showSnackBarError(
        context, "Este servicio esta deshabilitado temporalmente");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                divider40(),
                SvgPicture.asset(
                  'assets/images/login.svg',
                  height: 180.0,
                ),
                divider30(),
                Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: KBrandPrimaryColor,
                  ),
                ),
                divider10(),
                TextFieldNormalWidget(
                  hintText: "Correo electrónico",
                  icon: Icons.email,
                  controller: _emailcontroller,
                ),
                divider20(),
                TextFieldPasswordWidget(
                  controller: _passwordcontroller,
                ),
                divider20(),
                ButtonCustonWidget(
                  text: "Iniciar Sesión",
                  icon: "check",
                  color: KBrandPrimaryColor,
                  onPressed: () {
                    _login();
                  },
                ),
                divider20(),
                Text(
                  "O ingresa con tus redes sociales",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                divider20(),
                ButtonCustonWidget(
                  text: "Iniciar sesión con Google",
                  icon: "google",
                  color: Color(0xfff84b2a),
                  onPressed: () {
                    _loginWithGoogle();
                  },
                ),
                divider20(),
                ButtonCustonWidget(
                  text: "Iniciar sesión con Facebook",
                  icon: "facebook",
                  color: Color(0xff507CC0),
                  onPressed: () {
                    _loginWithFacebook();
                  },
                ),
                divider10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    divider10(),
                    Text(
                      "¿Aún no estás registrado?",
                      style: TextStyle(fontSize: 20),
                    ),
                    divider10(),
                    divider10Width(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Registrate!!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 3, 204),
                            fontSize: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
