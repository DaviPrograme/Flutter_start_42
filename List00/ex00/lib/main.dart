import 'package:flutter/material.dart';

void main() {
  runApp(SinglePage());
}

class SinglePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fator = 0.05;
    double sizeFont = height < width ? height * fator : width * fator;

    return MaterialApp(
      home: Scaffold(
         appBar: AppBar( title: Text("ex00", style: TextStyle(fontSize: sizeFont))),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.all(20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                child: Text(
                  "42 São Paulo",
                  style: TextStyle(color: Colors.black, fontSize: sizeFont),
                ),
              ),
              ElevatedButton(onPressed: () => print("Button pressed"), child: Text("Press", style: TextStyle(fontSize: sizeFont, ),))
            ]
          )
        )
      )
    );
  }
}