import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/main_page.dart';
import 'package:housey/views/register_screen.dart';
import 'package:housey/views/showactivity_screen.dart';
import 'anasayfa_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email_controller = new TextEditingController();
  final TextEditingController password_controller = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? errormsg;

  Route _createRouteMain() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AnasayfaScreen(),
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

  void logIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: 'Giriş Başarılı'),
                  Navigator.pushReplacement(context, _createRouteMain()),
                });
      } on FirebaseAuthException catch (error) {
        errormsg = "Giriş başarısız";
      }
      Fluttertoast.showToast(msg: errormsg!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final emailfield = TextFormField(
      controller: email_controller,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Geçerli bir email adresi giriniz.");
        }
        return null;
      },
      onSaved: (value) {
        email_controller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordfield = TextFormField(
      controller: password_controller,
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Şifre giriniz.");
        }
        return null;
      },
      onSaved: (value) {
        password_controller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.password, color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        hintText: "Şifre",
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // final loginButton = (Material(
    //   elevation: 10,
    //   borderRadius: BorderRadius.circular(50),
    //   color: Colors.deepPurpleAccent[400],
    //   child: MaterialButton(
    //     padding: EdgeInsets.all(20.0),
    //     minWidth: MediaQuery.of(context).size.width,
    //     onPressed: () {
    //       logIn(email_controller.text, password_controller.text);
    //     },
    //     child: Text(
    //       "Giriş Yap",
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 20,
    //         color: const Color(0xFF527DAA),
    //         fontWeight: FontWeight.bold,
    //         letterSpacing: 2,
    //         fontFamily: 'OpenSans',
    //       ),
    //     ),
    //   ),
    // ));
final loginButton = (Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF232946),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
         logIn(email_controller.text, password_controller.text);
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

    return Scaffold(
      // appBar: AppBar(
      //  title: Image.asset('assets/My_project_1.png'),
      //   elevation: 0.1,
      //   backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/My_project_1.png'),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: emailfield,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: passwordfield,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loginButton,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Hesabınız yoksa kaydolmak için tıklayabilirsiniz. ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Kayıt ol',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
