import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final UserModel? userModel;
  const NavBar({Key? key, this.userModel}) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  @override
  Widget build(BuildContext context) {

    final screens = [
      Home(userModel: widget.userModel,),
      const ListReunion(),
  ];

    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.list, size: 30),
      const Icon(Icons.info, size: 30),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.transparent,
          color: Colors.blue,
          buttonBackgroundColor: Colors.green,
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          items: items,
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ),
      ),
    );
  }
}
