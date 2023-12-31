import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';

class StateSearchFieldBar extends State<SearchFieldBar>{
  final void Function(Widget) updateWidgetBody;
  final TextEditingController _searchFieldController = TextEditingController();
  

  StateSearchFieldBar(this.updateWidgetBody);

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
      Position? teste;
      try{
        teste = await _determinePositionGPS();
        updateWidgetBody( 
          AutoSizeText('Latitude: ${teste.latitude.toString()} Longitude: ${teste.longitude.toString()}',
            maxFontSize: maxFont,
            minFontSize: minFont,
            maxLines: 1,
            style: TextStyle(fontSize: size * 0.1),
          )
        );
      } catch (e) {
        print("Error: ${e.toString()}." );
        updateWidgetBody(
          AutoSizeText("Geolocation is not avaliable, please enable it in your App settings",
            maxFontSize: maxFont,
            minFontSize: minFont,
            maxLines: 1,
            style: TextStyle(fontSize: size * 0.1, color: Colors.red),
          )
        );
      }
      _searchFieldController.clear();
    }

    void getCurrentWeatherRegion(String searchText) async {
      if(searchText.isEmpty){
        return;
      }
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final region = await regionRepository.getRegionFocus(searchText);
        final response = await regionRepository.callAPICurrentWeather(region);
        final body = jsonDecode(response.body);
        if(response.statusCode == 200){
          updateWidgetBody(
            Column(
              children: [
                AutoSizeText(region.name,
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.04),
                ),
                AutoSizeText('Latitude: ${region.latitude} Longitude: ${region.longitude}',
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.04),
                ),
                AutoSizeText("${body["current_weather"]["temperature"].toString()}ºC",
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.04),
                ),
              ],
            )
          );
        } else if(response.statusCode == 404){
          throw Exception("[CurrentWeather] URL not found.");
        } else {
          throw Exception("[CurrentWeather] Unable to load region information.");
        }
        }catch(e){
          updateWidgetBody(
            Text(e.toString(), style: TextStyle(fontSize: size * 0.04, color: Colors.red),),
          );
      }
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
          onSubmitted: getCurrentWeatherRegion,
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
            getCurrentWeatherRegion(suggestion.toString());
          });
        },
      )
    );
  }

}

class SearchFieldBar extends StatefulWidget{
  final void Function(Widget) updateWidgetBody;
  SearchFieldBar(this.updateWidgetBody);

  @override
  State<SearchFieldBar> createState() {
    return StateSearchFieldBar(updateWidgetBody);
  }
}