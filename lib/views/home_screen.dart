import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Route _createRouteLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteRegister() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = (Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF232946),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).push(_createRouteLogin());
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
      color: Color(0xFF232946),
      child: MaterialButton(
        padding: EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).push(_createRouteRegister());
        },
        child: Text(
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
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //         ),
        //         child: Text(
        //           'Housey',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 24,
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.home),
        //         title: Text('Home'),
        //         onTap: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => HomePage(title: 'Home')));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.login),
        //         title: Text('Giriş yap'),
        //         onTap: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => LoginScreen()));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.account_circle),
        //         title: Text('Kayıt ol'),
        //         onTap: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => RegisterScreen()));
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        backgroundColor: Colors.deepPurple[200],
        // appBar: AppBar(
        //   title: Image.asset('assets/My_project_1.png'),
        //   elevation: 0.1,
        //   backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        //   automaticallyImplyLeading: false,
        //   leading: Builder(
        //     builder: (context) => IconButton(
        //         onPressed: () => Scaffold.of(context).openDrawer(),
        //         icon: Icon(Icons.menu_rounded)),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => HomePage(title: 'Home')));
        //       },
        //       icon: Icon(Icons.home),
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => RegisterScreen()));
        //         },
        //         icon: Icon(Icons.app_registration_rounded)),
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => LoginScreen()));
        //         },
        //         icon: Icon(Icons.login))
        //   ],
        // ),
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
