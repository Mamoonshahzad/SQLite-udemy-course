import 'package:flutter/material.dart';
import 'package:sqlite_app_udemy/view/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My cool app',
      theme: ThemeData(
          brightness: Brightness.dark, primaryColor: Colors.lightBlue[800]),
      home: const HomeScreen(),
    );
  }
}
