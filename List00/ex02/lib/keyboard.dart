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
                Button.number("7"),
                Button.number("8"),
                Button.number("9"),
                Button.clear("C"),
                Button.clear("AC"),
              ]
            ),
             ButtonRow(
              [
                Button.number("4"),
                Button.number("5"),
                Button.number("6"),
                Button.arithmetic("+"),
                Button.arithmetic("-"),
              ]
            ),
            ButtonRow(
              [
                Button.number("1"),
                Button.number("2"),
                Button.number("3"),
                Button.arithmetic("*"),
                Button.arithmetic("/"),
              ]
            ),
             ButtonRow(
              [
                Button.number("0", true),
                Button.point("."),
                Button.arithmetic("=", true),
              ]
            ),
          ],
        ),
    );
  }
}