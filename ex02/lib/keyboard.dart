import 'package:flutter/material.dart';
import 'button.dart';
import 'buttonRow.dart';

class Keyboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
          children: [
            ButtonRow(
              [
                Button("7"),
                Button("8"),
                Button("9"),
                Button("C"),
                Button("AC"),
              ]
            ),
             ButtonRow(
              [
                Button("4"),
                Button("5"),
                Button("6"),
                Button("+"),
                Button("-"),
              ]
            ),
            ButtonRow(
              [
                Button("1"),
                Button("2"),
                Button("3"),
                Button("*"),
                Button("/"),
              ]
            ),
             ButtonRow(
              [
                Button("0", true),
                Button("."),
                Button("="),
              ]
            ),
          ],
        ),
    );
  }
}