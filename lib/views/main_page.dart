import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOUSEY"),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: Center(
        child: Text("Uygulama ana sayfası"),
      ),
    );
  }
}
