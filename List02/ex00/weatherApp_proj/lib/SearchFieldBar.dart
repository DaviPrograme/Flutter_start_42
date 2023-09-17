import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StateSearchFieldBar extends State<SearchFieldBar>{
  final void Function(String) updateSearchText;
  final TextEditingController _searchFieldController = TextEditingController();

  StateSearchFieldBar(this.updateSearchText);

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }


Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.'
    );
  }

  return await Geolocator.getCurrentPosition();
}

  void onPressedGeolocation() async {
    Position? teste;
    try{
      teste = await _determinePosition();
      updateSearchText('Latitude: ${teste.latitude.toString()} Longitude: ${teste.longitude.toString()}'); 
    } catch (e) {
      print("Error: ${e.toString()}." );
      updateSearchText("Geolocation is not avaliable, please enable it in your App settings");
    }
    _searchFieldController.clear();
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