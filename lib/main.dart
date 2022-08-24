import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:be_my_interpreter_2/firebase_options.dart';
import 'package:be_my_interpreter_2/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<AuthService>(create: (_) => AuthService(),),
    ], 
    child:
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Muli",
        appBarTheme: const AppBarTheme(
          color: Color(0XFF4FA3A5),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Muli"),
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0XFF4FA3A5),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,) 
    );
  }
}
