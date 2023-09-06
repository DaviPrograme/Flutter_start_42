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
        appBar: AppBar(
          title: Text("Single Page 42"),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text(
              "Pressione",
              style: TextStyle(fontSize: sizeFont),
            ),
            onPressed: () => print("Button pressed"),
          )
        ),
      ),
    );
  }
}