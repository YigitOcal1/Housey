import 'package:flutter/material.dart';
import 'package:housey/views/anasayfa_screen.dart';
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

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
        
        showSelectedLabels: true, 
        showUnselectedLabels: true,
        backgroundColor: Color(0xff38547C),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF1C2834),
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
              Icons.accessibility,
            ),
            label: "Keşfet",
          ),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.live_tv,
              ),
              label: "Profil"),
         
            
          BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
              ),
              label: "d"),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (_selectedIndex == 0) {
            var route =
                Navigator.pushReplacement(context, _createRouteCreateAnasayfa());
          } else if (_selectedIndex == 1) {
            var route =
                MaterialPageRoute(builder: (BuildContext context) => ShowActivity());
            Navigator.of(context).push(route);
          } else if (_selectedIndex == 2) {
            var route =
                MaterialPageRoute(builder: (BuildContext context) => ProfileScreen());
            Navigator.of(context).push(route);
          } 
        });
  }
}