import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const int colorCode = 0xFF232946;

  Color colorTheme = const Color(colorCode);
  NetworkImage networkImagePlaceHolder =
      const NetworkImage('https://www.woolha.com/media/2020/03/eevee.png');
  
  static const String houseyLogoPath='assets/My_project_1.png';

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














}

