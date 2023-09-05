
import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  final String text;
  final String bkgColor;
  final String textColor;
  final bool isBigButton;
  final Function(String) action;

  Button(this.text, this.action, [this.isBigButton = false, this.bkgColor = "0x00000000", this.textColor = "0xFFFFFFFF"]);
  Button.number(this.text, this.action, [this.isBigButton = false, this.bkgColor = "0xC3353535", this.textColor = "0xFFFFFFFF"]);
  Button.point(this.text, this.action, [this.isBigButton = false, this.bkgColor = "0xC3353535", this.textColor = "0xFFFFFFFF"]);
  Button.clear(this.text, this.action, [this.isBigButton = false, this.bkgColor = "0xC3252525", this.textColor = "0xC3FC1717"]);
  Button.arithmetic(this.text, this.action, [this.isBigButton = false, this.bkgColor = "0xFFFC8321", this.textColor = "0xFFFFFFFF"]);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isBigButton ? 2 : 1,
      child: ElevatedButton(
        onPressed: () => action(text), 
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(int.parse(bkgColor))),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        child: Text(text, style: TextStyle(color: Color(int.parse(textColor)))),
      )
    );
  }
}