import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/components/widgets/RoutesAnimations.dart';
import 'package:housey/utils/constants.dart';
import 'package:housey/views/create_activity_screen.dart';
import 'package:housey/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:housey/views/showactivity_screen.dart';
import 'main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  //final usernamecontroller = new TextEditingController();
  final confirmpasswordcontroller = new TextEditingController();
  String? errormsg;
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;

  void register(String email, String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel usermodel = UserModel();
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async => {
                  usermodel.email = user!.email,
                  usermodel.uid = user.uid,
                  usermodel.username = user.email!.replaceAll("@gmail.com", ""),
                  await firestore
                      .collection("users")
                      .doc(user.uid)
                      .set(usermodel.toMap()),
                  Fluttertoast.showToast(msg: "Hesap oluşturuldu")
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: 'Hata! Hesap oluşturulamadı.');
        });
      } on FirebaseAuthException catch (error) {
        errormsg = "Kayıt başarısız";
      }
    }
  }

  sendFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel usermodel = UserModel();
    usermodel.email = user!.email;
    usermodel.uid = user.uid;
    usermodel.username = user.email!.replaceAll("@gmail.com", "");

    await firestore.collection("users").doc(user.uid).set(usermodel.toMap());

    Fluttertoast.showToast(msg: "Hesap oluşturuldu");
    Navigator.of(context).push(RouteAnimations().createRouteCreateMainScreen());
  }

  @override
  Widget build(BuildContext context) {
    final emailfield = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Lütfen email adresinizi giriniz");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Lütfen geçerli bir email adresi giriniz");
        }
        return null;
      },
      onSaved: (value) {
        emailcontroller.text = value!;
      },
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //fillColor: Colors.amber,
          filled: true,
          prefixIcon: Icon(Icons.email, color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final passwordfield = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordcontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Kayıt olabilmek için şifre giriniz");
        }
        if (!regex.hasMatch(value)) {
          return ("Geçerli bir şifre giriniz.(Min. 6 Karakter)");
        }
      },
      onSaved: (value) {
        passwordcontroller.text = value!;
      },
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_outlined, color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Şifre",
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordcontroller,
      obscureText: true,
      validator: (value) {
        if (confirmpasswordcontroller.text != passwordcontroller.text) {
          return "Şifreler eşleşmiyor";
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordcontroller.text = value!;
      },
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_outlined, color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Şifrenizi onaylayınız",
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final registerButton = (Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF232946),
      child: MaterialButton(
        padding: EdgeInsets.all(20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          register(emailcontroller.text, passwordcontroller.text);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Image.asset('assets/My_project_1.png'),
      //   elevation: 0.1,
      //   backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      // ),

      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: Constants().boxDecorationApp,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Constants.houseyLogoPath),
                  SizedBox(height: 55.0),
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
                    child: confirmPasswordField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: registerButton,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Hesabınız varsa giriş için tıklayabilirsiniz. ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Giriş yap',
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
