import 'package:flutter/material.dart';

class WeatherNavBar extends StatelessWidget{
  final void Function(int) _selectPage;
  final int _index;

  WeatherNavBar(this._selectPage, this._index);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double iconSize = size * 0.05;
    double selectedFontTextSize = size * 0.05;
    double unselectedFontTextSize = size * 0.03;

    return  BottomNavigationBar(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.orange,
      selectedFontSize: selectedFontTextSize,
      unselectedFontSize: unselectedFontTextSize,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week , size: iconSize), label: "Currently"),
        BottomNavigationBarItem(icon: Icon(Icons.today, size: iconSize),  label: "Today"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_sharp, size: iconSize),  label: "Weekly"),
      ],
      currentIndex: _index,
      onTap: _selectPage,
    );
  }
}