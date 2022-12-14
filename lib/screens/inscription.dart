import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/languages.dart';
import 'package:be_my_interpreter_2/screens/nav_bar.dart';
import 'package:be_my_interpreter_2/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constantes/theme_variable.dart';

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
  UserType? userType = UserType.autre;
  UserModel? userModel;
  Language? language;
  List<Language?>? languages = [];

  Widget _prenomIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.account_circle_outlined,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget _passwordIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.lock_outline,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget _emailIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.email_outlined,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget? _buildName(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Votre prénom', 'Prénom', _prenomIcon(size)),
      cursorColor: APP_PRIMARY,
      controller: nameController,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  Widget? _buildLastName(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Votre nom', 'Nom', _prenomIcon(size)),
      cursorColor: APP_PRIMARY,
      controller: lastNameController,
      
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  Widget? _buildEmail(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Votre email', 'Email', _emailIcon(size)),
      cursorColor: APP_PRIMARY,
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

  Widget? _buildPassword(Size size) {
    return TextFormField(
      decoration: inputStyle(
          size, 'Votre mot de passe', 'Mot de passe', _passwordIcon(size)),
      cursorColor: APP_PRIMARY,
      controller: passwordController,
      obscureText: true,
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

  Widget? _buildConfirmPassword(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Confirmez votre mot de passe',
          'Confirmez le mot de passe', _passwordIcon(size)),
      cursorColor: APP_PRIMARY,
      obscureText: true,
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

  Widget? _buildCategorie(Size size) {
    return Column(
      children: [
        const Text(
          "Vous êtes :",
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Radio<UserType>(
                    activeColor: APP_PRIMARY,
                    value: UserType.autre,
                    groupValue: userType,
                    onChanged: (UserType? value) {
                      setState(() {
                        userType = value;
                      });
                    }),
                const Text('Autre'),
              ],
            ),
            Row(
              children: [
                Radio<UserType>(
                    activeColor: APP_PRIMARY,
                    value: UserType.sourd,
                    groupValue: userType,
                    onChanged: (UserType? value) {
                      setState(() {
                        userType = value;
                      });
                    }),
                const Text('Sourd(e)'),
              ],
            ),
            Row(
              children: [
                Radio<UserType>(
                    activeColor: APP_PRIMARY,
                    value: UserType.interpret,
                    groupValue: userType,
                    onChanged: (UserType? value) {
                      setState(() {
                        userType = value;
                      });
                    }),
                const Text('Interprète'),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget? _buildLanguageSelection() {
    return OutlinedButton(
        onPressed: () => {},
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            color: APP_PRIMARY,
            width: 1.5,
          )
        ), 
        child: _buildMultipleLanguage()!,
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

    return languages!.isEmpty ? _buildListLanguage(title: 'Choisissez...', onTap: onTap) : _buildListLanguage(title: languagesText, onTap: onTap);
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
      trailing: const Icon(Icons.arrow_drop_down, color: APP_PRIMARY, size: 30,),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Inscrivez vous")),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/illustration/undraw_welcome_re_h3d9.svg',
                  height: size.height * 0.20,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildName(size)!,
                const SizedBox(
                  height: 20,
                ),
                _buildLastName(size)!,
                const SizedBox(
                  height: 20,
                ),
                _buildEmail(size)!,
                const SizedBox(
                  height: 20,
                ),
                _buildPassword(size)!,
                const SizedBox(
                  height: 20,
                ),
                _buildConfirmPassword(size)!,
                const SizedBox(
                  height: 20,
                ),
                _buildCategorie(size)!,
                const SizedBox(
                  height: 20,
                ),
                userType != UserType.autre ? _buildLanguageSelection()! : const SizedBox(height: 0.01,),

                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {

                      userModel =  await authService.createUser(nameController.text, lastNameController.text, emailController.text, passwordController.text, userType, languages);

                      nameController.clear();
                      lastNameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
                      languages = [];

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => NavBar(
                                    userModel: userModel,
                                  ))));
                    }
                  },
                  style: buttonStyle(size),
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous avez déjà un compte ? "),
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context)
                        },
                        child: const Text(
                          "Cliquez ici",
                          style: TextStyle(
                              color: APP_PRIMARY,
                              decoration: TextDecoration.underline),
                        ))
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
