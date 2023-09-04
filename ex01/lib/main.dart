import 'package:flutter/material.dart';

void main() {
  runApp(Hello42());
}


class StateHello42 extends State<Hello42>{
  bool isInitial = true;

  void pressButton() {
    setState(() {
      isInitial = isInitial ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar( title: Text("ex01", style: TextStyle(fontSize: 42))),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue,),
                child: Text(
                  isInitial ? "42 São Paulo" : "Hello World!",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ), 
              ),
              ElevatedButton(onPressed: pressButton, child: Text("Press"))
            ]
          )
        ) 
      ),
    );
  }
}

class Hello42 extends StatefulWidget{
  @override
  State<Hello42> createState() {
   return StateHello42();
  }
}
