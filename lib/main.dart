import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        primaryIconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
      ),
      home: HomePage(),
    );
  }
}
