import 'package:be_my_interpreter_2/webRTC.dart';
import 'package:be_my_interpreter_2/wrapper.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  WebRTC());
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
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
