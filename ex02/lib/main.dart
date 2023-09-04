import 'package:flutter/material.dart';
import 'display.dart';
import 'keyboard.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        title: Container(
          width: double.infinity,
          child: Center(
            child: Text("Calculator"),
          ),
        ) 
      ),
      body: Column(children: [
          DisplayCalculator(),
          Keyboard()
        ]),
     ),
    );
  }
}
