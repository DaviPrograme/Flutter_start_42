import 'package:flutter/material.dart';

class WeatherPages extends StatelessWidget{
  final void Function(int) _selectPage;
  final PageController _pageController;

  WeatherPages(this._selectPage, this._pageController);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double fontTextSize = size * 0.1;

    List<Widget> pages = [
      Center(child: Text("CURRENTLY", style: TextStyle(fontSize: fontTextSize))),
      Center(child: Text("TODAY", style: TextStyle(fontSize: fontTextSize))),
      Center(child: Text("WEEKLY", style: TextStyle(fontSize: fontTextSize))),
    ];

    return  PageView(
      controller: _pageController,
      onPageChanged: _selectPage,
      children: pages,
    );
  }
}