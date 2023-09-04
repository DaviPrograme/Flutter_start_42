
import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  final String text;
  final bool big;

  Button(this.text, [this.big = false]);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: big ? 3 : 1,
      child: ElevatedButton(
        onPressed: () => print(text), 
        child: Text(text),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
      )
    );
  }
}