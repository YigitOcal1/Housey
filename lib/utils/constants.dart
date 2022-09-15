import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const int colorCode = 0xFF232946;

  Color colorTheme = const Color(colorCode);
  NetworkImage networkImagePlaceHolder =
      const NetworkImage('https://www.woolha.com/media/2020/03/eevee.png');

  Container flexibleSpaceContainer = Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1E0B36),
          Color(0xFFCA3782),
        ],
        stops: [0.1, 0.9],
      ),
    ),
  );

  Container expandFullPageContainer = Container(
    height: double.infinity,
    width: double.infinity,
    decoration: const BoxDecoration(
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
  );

  BoxDecoration boxDecorationApp = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFCA3782),
        Color(0xFF1E0B36),
      ],
      stops: [0.1, 0.9],
    ),
  );


TextFormField emailField=TextFormField(
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














}

