import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/main_page.dart';
import 'package:housey/views/register_screen.dart';

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

  void logIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: 'Giriş Başarılı'),
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => MainPage())),
                });
      } on FirebaseAuthException catch (error) {
        errormsg = "Giriş başarısız";
      }
      Fluttertoast.showToast(msg: errormsg!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      controller: email_controller,
      keyboardType: TextInputType.emailAddress,
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
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordfield = TextFormField(
      controller: password_controller,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Şifre giriniz.");
        }
        return null;
      },
      onSaved: (value) {
        email_controller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.password),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Şifre",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final loginButton = (Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(50),
      color: Colors.deepPurpleAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          logIn(email_controller.text, password_controller.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text("HOUSEY"),
        backgroundColor: Colors.deepPurple[600],
      ),
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.deepPurple[200],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        Text(
                            "Hesabınız yoksa kaydolmak için tıklayabilirsiniz.  "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Kaydol",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
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
      ),
    );
  }
}
