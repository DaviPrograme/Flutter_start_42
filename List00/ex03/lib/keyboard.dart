import 'package:flutter/material.dart';
import 'button.dart';
import 'buttonRow.dart';

class Keyboard extends StatelessWidget{

  final Function(String) action;

  Keyboard(this.action);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
          children: [
            ButtonRow(
              [
                Button.number("7", action),
                Button.number("8", action),
                Button.number("9", action),
                Button.clear("C", action),
                Button.clear("AC", action),
              ]
            ),
             ButtonRow(
              [
                Button.number("4", action),
                Button.number("5", action),
                Button.number("6", action),
                Button.arithmetic("+", action),
                Button.arithmetic("-", action),
              ]
            ),
            ButtonRow(
              [
                Button.number("1", action),
                Button.number("2", action),
                Button.number("3", action),
                Button.arithmetic("*", action),
                Button.arithmetic("/", action),
              ]
            ),
             ButtonRow(
              [
                Button.number("0",action, true),
                Button.point(".", action),
                Button.arithmetic("=", action, true),
              ]
            ),
          ],
        ),
    );
  }
}