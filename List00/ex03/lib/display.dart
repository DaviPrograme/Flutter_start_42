import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DisplayCalculator extends StatelessWidget{
  final String expression;
  final String result;

  DisplayCalculator(this.expression, this.result);

 @override
  Widget build(BuildContext context) {
    double defineMaxFontSize = 80;
    double defineMinFontSize = 10;
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromARGB(255, 122, 121, 121)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            AutoSizeText (
              expression,
              minFontSize: defineMinFontSize,
              maxFontSize: defineMaxFontSize,
              maxLines: 1, 
              textAlign: TextAlign.end,
              style: TextStyle( fontWeight: FontWeight.w100, fontSize: defineMaxFontSize, color: Colors.white)
            ),
             AutoSizeText (
              result,
              minFontSize: defineMinFontSize,
              maxFontSize: defineMaxFontSize,
              maxLines: 1, 
              textAlign: TextAlign.end,
              style: TextStyle( fontWeight: FontWeight.w100, fontSize: defineMaxFontSize, color: Colors.white)
            ),
          ]),
      )
    );
  }
}