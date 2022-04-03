import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/languages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  UserType? userType = UserType.sourd;
  UserModel? userModel;
  Language? language;
  List<Language?>? languages = [];

  //Firebase
  final _auth = FirebaseAuth.instance;

  Widget? _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Prénom :"),
      controller: nameController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  Widget? _buildLastName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nom :"),
      controller: lastNameController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  Widget? _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email :"),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
        /*if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
          return "Entrez un email valide s'il vous plait";
        }
        return null;*/
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

  Widget? _buildConfirmPassword() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: "Confirmer votre mot de passe :"),
      controller: confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (confirmPasswordController.text.length > 6 &&
            confirmPasswordController.text != passwordController.text) {
          return "Vos mots de passes ne correspondent pas !";
        }
        return null;
      },
    );
  }

  Widget? _buildCategorie() {
    return Column(
      children: [
        const Text(
          "Vous êtes :",
        ),
        ListTile(
          title: const Text("Sourd/Sourde"),
          leading: Radio<UserType>(
              value: UserType.sourd,
              groupValue: userType,
              onChanged: (UserType? value) {
                setState(() {
                  userType = value;
                });
              }),
        ),
        ListTile(
          title: const Text("Interprete"),
          leading: Radio<UserType>(
              value: UserType.interpret,
              groupValue: userType,
              onChanged: (UserType? value) {
                setState(() {
                  userType = value;
                });
              }),
        ),
      ],
    );
  }

  Widget? _buildLanguageSelection() {
    return Card(
      child: _buildMultipleLanguage(),
    );
  }

  Widget? _buildMultipleLanguage() {
    final languagesText =
        languages!.map((language) => language!.language).join(', ');
    // ignore: prefer_function_declarations_over_variables
    final onTap = () async {
      final languages = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LanguageList(
                    isMultiSelection: true,
                    listLanguages: List.of(this.languages!),
                  )));

      if (languages == null) return;

      setState(() => this.languages = languages);
    };

    return languages == null
        ? _buildListLanguage(title: 'No languages', onTap: onTap)
        : _buildListLanguage(title: languagesText, onTap: onTap);
  }

  Widget? _buildListLanguage({
    @required String? title,
    @required VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscrivez vous")),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName()!,
                _buildLastName()!,
                _buildEmail()!,
                _buildPassword()!,
                _buildConfirmPassword()!,
                _buildCategorie()!,
                _buildLanguageSelection()!,
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () async {
                      signUp(emailController.text, passwordController.text);
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //Calling the firebase firestore

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    userModel = UserModel(
        id: user!.uid,
        firstName: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        languages: languages!,
        userType: userType!);

    dynamic myarray = [];
    for (var element in userModel!.languages!) {
      myarray.add(firebaseFirestore.doc("langues/" + (element!.id).toString()));
    }

    await firebaseFirestore.collection('users').doc(user.uid).set({
      "id": userModel!.id,
      "firstName": userModel!.firstName,
      "lastName": userModel!.lastName,
      "email": userModel!.email,
      "password": userModel!.password,
      "languages": myarray,
      "userType": userModel!.userType.name,
    });

    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    Fluttertoast.showToast(msg: "Votre compte a été créer avec succes !");
  }
}

