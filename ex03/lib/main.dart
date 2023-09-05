import 'package:flutter/material.dart';
import 'display.dart';
import 'keyboard.dart';
import 'memory.dart';

void main() {
  runApp(Calculator());
}

class StateCalculator extends State<Calculator> { 
  Memory memory = Memory();

 void buttonPressed (String action) {
  setState(() {
    memory.buttonPressedAction(action);
  });
 }

 
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
          DisplayCalculator(memory.expression, memory.result),
          Keyboard(buttonPressed)
        ]),
     ),
    );
  }
}

class Calculator extends StatefulWidget{
  @override
  State<Calculator> createState() {
    return StateCalculator();
  }
}
