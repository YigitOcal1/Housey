import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/components/widgets/RoutesAnimations.dart';
import 'package:housey/utils/constants.dart';
import 'package:housey/views/main_page.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentWidget = Container();
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        return setState(() => _currentWidget = HomePage(title: 'home'));
      case 1:
        return setState(() => _currentWidget = LoginScreen());
      case 2:
        return setState(() => _currentWidget = RegisterScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = (Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25.0),
      color: Constants().colorTheme,
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).push(RouteAnimations().createRouteLogin());
        },
        child: Text(
          "Giriş Yap",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    ));

    final registerButton = (Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(Constants.colorCode),
      child: MaterialButton(
        padding: EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context)
              .push(RouteAnimations().createRouteRegisterScreen());
        },
        child: const Text(
          "Kayıt ol",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFamily: 'OpenSans'),
        ),
      ),
    ));
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurple[200],
        body: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFCA3782),
                  Color(0xFF1E0B36),
                ],
                stops: [0.1, 0.9],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/My_project_1.png'),
                SizedBox(height: 200.0),
                // Padding(padding: EdgeInsets.only(top: 100.0)),
                loginButton,
                SizedBox(height: 25.0),
                registerButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
