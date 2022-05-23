import 'package:flutter/material.dart';
import 'package:housey/views/anasayfa_screen.dart';
import 'package:housey/views/main_page.dart';
import 'package:housey/views/showactivity_screen.dart';
import 'package:housey/views/profile_screen.dart';
import 'package:housey/views/home_screen.dart';

int _selectedIndex = 0;

class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
}

Route _createRouteCreateAnasayfa() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AnasayfaScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
Route _createRouteCreateExplore() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ShowActivity(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
Route _createRouteCreateProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
Route _createRouteCreateAddActivity() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFF232946),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent[100],
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
            ),
            label: "Ana sayfa",
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.explore_off_rounded,
            ),
            label: "Keşfet",
          ),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.portrait_rounded,
              ),
              label: "Profil",
              ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.create_rounded,
              ),
              label: "Aktivite Oluştur",
              ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (_selectedIndex == 0) {
            var route = Navigator.pushReplacement(
                context, _createRouteCreateAnasayfa());
          } else if (_selectedIndex == 1) {
            var route = Navigator.pushReplacement(
                context, _createRouteCreateExplore());
          } else if (_selectedIndex == 2) {
            var route = Navigator.pushReplacement(
                context, _createRouteCreateProfile());
          } else if (_selectedIndex == 3) {
            var route = Navigator.pushReplacement(
                context, _createRouteCreateAddActivity());
          }
        });
  }
}
