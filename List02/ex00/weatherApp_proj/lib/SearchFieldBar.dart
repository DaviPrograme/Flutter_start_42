import 'package:flutter/material.dart';

class StateSearchFieldBar extends State<SearchFieldBar>{
  final void Function(String) updateSearchText;
  final TextEditingController _searchFieldController = TextEditingController();

  StateSearchFieldBar(this.updateSearchText);

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  void onPressedGeolocation(){
    _searchFieldController.clear();
    updateSearchText("Geolocation"); 
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double iconSize = size * 0.06;
    double fontTextSize = size * 0.045;

    return  Container(
              color: Colors.blue, 
              child: TextField(
                onSubmitted: updateSearchText,
                decoration:  InputDecoration(
                  hintText: "  please, write here...",
                  hintStyle: TextStyle(fontSize: fontTextSize, fontStyle: FontStyle.italic) ,
                  prefixIcon: Icon(Icons.search, color: Colors.orange, size: iconSize),
                  suffixIcon: IconButton(onPressed: onPressedGeolocation, 
                    icon: Icon(Icons.location_on, color: Colors.orange, size: iconSize),
                  ) 
                ) ,
                controller: _searchFieldController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontTextSize,
                ),
              ),
            );
  }

}

class SearchFieldBar extends StatefulWidget{
  final void Function(String) updateSearchText;
  SearchFieldBar(this.updateSearchText);

  @override
  State<SearchFieldBar> createState() {
    return StateSearchFieldBar(updateSearchText);
  }
}