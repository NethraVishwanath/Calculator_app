

import 'package:flutter/material.dart';

import 'calculator_ui.dart';




void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

