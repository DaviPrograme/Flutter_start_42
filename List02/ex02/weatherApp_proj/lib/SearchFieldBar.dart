import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:weather/data/models/regionModel.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StateSearchFieldBar extends State<SearchFieldBar>{
  final void Function(RegionModel) setRegion;
  final void Function(String) searchRegion;
  final TextEditingController _searchFieldController = TextEditingController();
  

  StateSearchFieldBar(this.setRegion, this.searchRegion);

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }


  Future<Position> _determinePositionGPS() async {
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

 
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double iconSize = size * 0.06;
    double fontTextFieldSize = size * 0.045;
    double maxFont = 100;
    double minFont = 10;

    void onPressedGeolocation() async {
      Position? region;
      try{
        region = await _determinePositionGPS();
        setRegion(RegionModel(name: "Here", region: "", country: "", latitude: region.latitude, longitude: region.longitude));
      } catch (e) {
        print("Error: ${e.toString()}.");
      }
      _searchFieldController.clear();
    }

    return  Container(
      color: Colors.blue,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _searchFieldController,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontTextFieldSize,
          ),
          onSubmitted: searchRegion,
          decoration:  InputDecoration(
            hintText: "  example: name, region, country",
            hintStyle: TextStyle(fontSize: fontTextFieldSize, fontStyle: FontStyle.italic) ,
            prefixIcon: Icon(Icons.search, color: Colors.orange, size: iconSize),
            suffixIcon: IconButton(
              onPressed: onPressedGeolocation,
              icon: Icon(Icons.location_on, color: Colors.orange, size: iconSize),
            )
          ),
        ),
        suggestionsCallback: (pattern) async {
          try{
            return await RegionRepository(client: HttpRepository()).getRegionsSuggestion(pattern);
          } catch(e){
            print(e);
            return [];
          }
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          setState(() {
            _searchFieldController.text = suggestion;
            searchRegion(suggestion.toString());
          });
        },
      )
    );
  }

}

class SearchFieldBar extends StatefulWidget{
  final void Function(RegionModel) setRegion;
  final void Function(String) searchRegion;
  SearchFieldBar(this.setRegion, this.searchRegion);

  @override
  State<SearchFieldBar> createState() {
    return StateSearchFieldBar(setRegion, this.searchRegion);
  }
}