import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

InputDecoration inputStyle(
    Size? size, String hintText, String labelText, Widget widget) {
  return InputDecoration(
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.black),
      gapPadding: 5,
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      gapPadding: 5,
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(
        color: Color(0XFF4FA3A5),
        width: 2.0,
      ),
      gapPadding: 5,
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      gapPadding: 5,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    floatingLabelStyle: const TextStyle(color: Color(0XFF4FA3A5)),
    errorStyle: const TextStyle(color: Colors.red),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 20,
    ),
    suffixIcon: widget,
    focusColor: const Color(0XFF4FA3A5),
    hintText: hintText,
    labelText: labelText,
  );
}

ButtonStyle buttonStyle(Size size) {
  return ElevatedButton.styleFrom(
    primary: const Color(0XFF4FA3A5),
    padding: const EdgeInsets.all(5.0),
    shape: const StadiumBorder(),
    minimumSize: const Size.fromHeight(43),
  );
}

class AccessDenied extends StatelessWidget {
  const AccessDenied({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/images/illustration/undraw_access_denied_re_awnf.svg', height: size.height * 0.8,),
            const Text(
              'Be My Interpreter',
              style: TextStyle(
                color: Color(0XFF4FA3A5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 7.5,
            ),
            const Text("Accés réfusé !"),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(onPressed: () => {
              Navigator.pop(context),
            }, 
            child:  const Icon(Icons.arrow_back, color: Colors.white,),
            backgroundColor: const Color(0XFF4FA3A5),
            )
           
          ],
        ),
      ),
    );
  }
}