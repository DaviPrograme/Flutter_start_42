import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DisplayCalculator extends StatelessWidget{
  final String expression;
  final String result;

  DisplayCalculator(this.expression, this.result);

 @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(color: Color.fromARGB(255, 122, 121, 121)),
          child: Column(children: [
            AutoSizeText (
              expression,
              minFontSize: 20,
              maxFontSize: 80,
              maxLines: 1, 
              textAlign: TextAlign.end,
              style: TextStyle( fontWeight: FontWeight.w100, fontSize: 80, color: Colors.white)
            ),
             AutoSizeText (
              result,
              minFontSize: 20,
              maxFontSize: 80,
              maxLines: 1, 
              textAlign: TextAlign.end,
              style: TextStyle( fontWeight: FontWeight.w100, fontSize: 80, color: Colors.white)
            ),
          ]),
      )
    );
  }
}