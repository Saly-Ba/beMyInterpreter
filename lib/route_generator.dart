import 'package:be_my_interpreter_2/screens/meeting_manager.dart';
import 'package:be_my_interpreter_2/screens/inscription.dart';
import 'package:be_my_interpreter_2/screens/chips.dart';
import 'package:be_my_interpreter_2/screens/nav_bar.dart';
import 'package:be_my_interpreter_2/wrapper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Wrapper());
      /*case '/langues':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => LanguesList(user: args));
        }

        return _errorRoute();*/

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
