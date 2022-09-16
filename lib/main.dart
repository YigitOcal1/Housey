import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'views/main_screen.dart';
import 'views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Housey',
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (snapShot.hasData) {
                return const MainScreen();
              } else {
                return HomePage(
                  title: 'Housey',
                );
              }
            },
          )),
    );
  }
}
