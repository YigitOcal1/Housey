import 'package:flutter/cupertino.dart';

class Constants{


static const int colorCode=0xFF232946;

Color colorTheme= const Color(colorCode);

Container flexibleSpaceContainer=Container(
          decoration: BoxDecoration(
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

}