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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fator = 0.05;
    double sizeFont = height < width ? height * fator : width * fator;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar( title: Text("ex01", style: TextStyle(fontSize: 42))),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.all(20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                child: Text(
                  isInitial ? "42 São Paulo" : "Hello World!",
                  style: TextStyle(color: Colors.black, fontSize: sizeFont),
                ), 
              ),
              ElevatedButton(onPressed: pressButton, child: Text("Press", style: TextStyle(fontSize: sizeFont, ),))
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
