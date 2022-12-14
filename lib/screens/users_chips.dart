import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:flutter/material.dart';

import '../constantes/theme_variable.dart';

class EmailChips extends StatefulWidget {
  final String? email;
  const EmailChips({Key? key, required this.email}) : super(key: key);

  @override
  State<EmailChips> createState() => _EmailChipsState();
}

class _EmailChipsState extends State<EmailChips> {
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserManager.getUsersEmail(widget.email!),
      builder: ((context, AsyncSnapshot<UserModel?> snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: Chip(label: Text('...',  style: TextStyle(color: Colors.white)), backgroundColor: APP_PRIMARY,),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){

          if(snapshot.hasData){
            userModel = snapshot.data!;

            return Chip(label: Text('${userModel!.firstName!} ${userModel!.lastName!}', style: const TextStyle(color: Colors.white)), backgroundColor: APP_PRIMARY,);
          }else {
            return const Center(
              child: Chip(label: Text('Pas de donées', style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,),
            );
          }
        }
        else{
          return const Center(
            child: Text('Une erreur est survenue')
          );
        }
      })
      );
  }
}