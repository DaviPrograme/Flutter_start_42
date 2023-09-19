import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';

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

    void updateWidgetWithTextField(String newText){
       updateWidgetBody( AutoSizeText(newText,
          maxFontSize: maxFont,
          minFontSize: minFont,
          maxLines: 1,
          style: TextStyle(fontSize: size * 0.1),
        ));
    }

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

    return  Container(
              color: Colors.blue, 
              child: TextField(
                onSubmitted: updateWidgetWithTextField,
                onChanged: (value) async {
                  try{
                    final http = HttpRepository();
                    final repository = RegionRepository(client: http);
                    final teste = await repository.getRegion();
                    print("DEVOLVEU ESTE VALOR: ${teste.first.name}");
                  }catch(e){
                    print("ERROR: $e");
                  }
                },
                decoration:  InputDecoration(
                  hintText: "  please, write here...",
                  hintStyle: TextStyle(fontSize: fontTextFieldSize, fontStyle: FontStyle.italic) ,
                  prefixIcon: Icon(Icons.search, color: Colors.orange, size: iconSize),
                  suffixIcon: IconButton(onPressed: onPressedGeolocation, 
                    icon: Icon(Icons.location_on, color: Colors.orange, size: iconSize),
                  ) 
                ) ,
                controller: _searchFieldController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontTextFieldSize,
                ),
              ),
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