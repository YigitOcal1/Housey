import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/main_page.dart';
import 'package:housey/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final confirmpasswordcontroller = new TextEditingController();
  String? errormsg;

  void register(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {sendFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        errormsg = "Kayıt başarısız";
      }
      Fluttertoast.showToast(msg: errormsg!);
    }
  }

  sendFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel usermodel = UserModel();
    usermodel.email = user!.email;
    usermodel.uid = user.uid;
    usermodel.username = usernamecontroller.text;

    await firestore.collection("users").doc(user.uid).set(usermodel.toMap());
    Fluttertoast.showToast(msg: "Hesap oluşturuldu");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final username = TextFormField(
        keyboardType: TextInputType.name,
        autofocus: false,
        controller: usernamecontroller,
        onSaved: (value) {
          usernamecontroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Kullanıcı adı",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailcontroller,
      onSaved: (value) {
        usernamecontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
    final password = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordcontroller,
      onSaved: (value) {
        usernamecontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifre",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordcontroller,
      obscureText: true,
      onSaved: (value) {
        confirmpasswordcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifrenizi onaylayınız",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
    final loginButton = (Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurpleAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          register(emailcontroller.text, passwordcontroller.text);
        },
        child: Text(
          "Kayıt ol",
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
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: username,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: email,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: password,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: confirmPasswordField,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loginButton,
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
