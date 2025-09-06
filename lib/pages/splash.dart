//asks users name
import 'package:MONEY_MANAGER/controllers/db_helper.dart';
import 'package:MONEY_MANAGER/pages/add_name.dart';
import 'package:MONEY_MANAGER/pages/homepage.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    getName(); //calls the getName function inside this file
  }

  Future getName() async {
    String? name = await dbHelper
        .getName(); //gets the name which is stored in sharedpreferences by calling getName fo db_helper.dart file
    //Now checks if the name is empty and if it is then goes to AddName else sends to homepage
    if (name != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }

  @override //returns the scaffold which allows us to show what we want to show on this page.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Image.asset(
            "assets/icon.png",
            width: 64.0,
            height: 64.0,
          ),
        ),
      ),
    );
  }
}
