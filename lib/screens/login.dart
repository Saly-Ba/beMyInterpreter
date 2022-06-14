//import 'package:be_my_interpreter/models.dart';
import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:flutter/material.dart';
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

  Widget? _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email :"),
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

  Widget? _buildPassword() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Mot de passe :"),
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
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
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmail()!,
            _buildPassword()!,
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => {
                      if (_formKey.currentState!.validate())
                        {
                          authService.signIn(
                              emailController.text, passwordController.text),
                          emailController.clear(),
                          passwordController.clear(),
                        }
                    },
                child: const Text("Log In"))
          ],
        )),
      )),
    );
  }
}
