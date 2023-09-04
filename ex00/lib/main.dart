import 'package:flutter/material.dart';

void main() {
  runApp(SinglePage());
}

class SinglePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Single Page 42"),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("Pressione"),
            onPressed: () => print("Button pressed"),
          )
        ),
      ),
    );
  }
}