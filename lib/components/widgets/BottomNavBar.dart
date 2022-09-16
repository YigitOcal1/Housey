import 'package:flutter/material.dart';
import 'package:housey/components/widgets/RoutesAnimations.dart';

int _selectedIndex = 0;

class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Ana sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_off_rounded,
            ),
            label: "Keşfet",
          ),
          BottomNavigationBarItem(
            icon: Icon(
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
                context, RouteAnimations().createRouteCreateMainScreen());
          } else if (_selectedIndex == 1) {
            var route = Navigator.pushReplacement(
                context, RouteAnimations().createRouteShowActivityScreen());
          } else if (_selectedIndex == 2) {
            var route = Navigator.pushReplacement(
                context, RouteAnimations().createRouteCreateProfile());
          } else if (_selectedIndex == 3) {
            var route = Navigator.pushReplacement(
                context, RouteAnimations().createRouteCreateAddActivity());
          }
        });
  }
}
