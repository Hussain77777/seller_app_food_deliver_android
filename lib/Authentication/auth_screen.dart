import 'package:flutter/material.dart';
import 'package:seller_app_food_deliver/Authentication/register.dart';


import 'login.dart';

class Auth_screen extends StatefulWidget {
  const Auth_screen({Key? key}) : super(key: key);

  @override
  _Auth_screenState createState() => _Auth_screenState();
}

class _Auth_screenState extends State<Auth_screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.amber],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: const Text(
            "iFood",
            style: TextStyle(
                color: Colors.white, fontSize: 60, fontFamily: "Lobster"),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "Register",
              )
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.amber],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child:  TabBarView(
            children: [Login(),Register()],
          ),
        ),
      ),
    );
  }
}
