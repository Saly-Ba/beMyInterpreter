//import 'package:be_my_interpreter/models.dart';
import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:be_my_interpreter_2/screens/inscription.dart';
import 'package:be_my_interpreter_2/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget _emailIcon(Size size){
    return Padding(
          padding: EdgeInsets.fromLTRB(
              0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
          child: const Icon(
            Icons.email_outlined,
            color: Color(0XFF4FA3A5),
            size: 27.5,
          ),
        );
  }

  Widget? _buildEmail(Size? size) {
    return TextFormField(
      decoration: inputStyle(size, 'Votre email', 'Email', _emailIcon(size!)),
      cursorColor: const Color(0XFF4FA3A5),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
          return "Entrez un email valide s'il vous plait";
        }
        return null;
      },
    );
  }

  Widget _passwordIcon(Size size){
    return Padding(
          padding: EdgeInsets.fromLTRB(
              0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
          child: const Icon(
            Icons.lock_outline,
            color: Color(0XFF4FA3A5),
            size: 27.5,
          ),
        );
  }

  Widget? _buildPassword(Size? size) {
    return TextFormField(
      decoration: inputStyle(size, 'Votre mot de passe', 'Mot de passe', _passwordIcon(size!)),
      cursorColor: const Color(0XFF4FA3A5),
      controller: passwordController,
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis";
        }
        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
          return "Veuillez entrer un mot de passe valide ! (un minimum de 6 caractères)";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Expanded(
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/illustration/undraw_enter_uhqk.svg',
                    height: size.height * 0.32,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Be My Interpreter',
                    style: TextStyle(
                      color: Color(0XFF4FA3A5),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Satisfy',
                    ),
                  ),
                  const SizedBox(
                    height: 7.5,
                  ),
                  const Text(
                    'Connectez vous à votre compte via votre email et  votre mot de passe',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildEmail(size)!,
                  const SizedBox(
                    height: 20,
                  ),
                  _buildPassword(size)!,
                  const SizedBox(
                    height: 0.2,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () => {},
                          child: const Text(
                            "Mot de passe oublié",
                            style: TextStyle(
                                color: Color(0XFF4FA3A5),
                                decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 0.6,
                  ),
                  SizedBox(
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () => {
                        if (_formKey.currentState!.validate())
                          {
                            authService.signIn(
                                emailController.text, passwordController.text),
                            emailController.clear(),
                            passwordController.clear(),
                          }
                      },
                      child: const Text("Se connecter"),
                      style: buttonStyle(size)
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                      "Vous n'avez pas de compte ? "),
                    TextButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserForm(),))
                      },
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(
                            color: Color(0XFF4FA3A5),
                            decoration: TextDecoration.underline),
                      ))
                    ],
                  )
                  
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
