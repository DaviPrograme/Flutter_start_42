import 'package:flutter/material.dart';
import './data/models/regionModel.dart';
import './data/models/regionModel.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';


class WeatherPages extends StatelessWidget{
  final void Function(int) _selectPage;
  final RegionModel? region;
  final PageController _pageController;

  WeatherPages(this._selectPage, this._pageController, this.region);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double fontTextSize = size * 0.1;
    double maxFont = 100;
    double minFont = 10;
    

    Future<Widget> getCurrentWeatherRegion(RegionModel region) async {
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPICurrentWeather(region);
        final body = jsonDecode(response.body);
        if(response.statusCode == 200){
            return Column(
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
            );
        } else if(response.statusCode == 404){
          throw Exception("URL not found.");
        } else {
          throw Exception("Unable to load region information.");
        }
        }catch(e){
            return Text(e.toString(), style: TextStyle(fontSize: size * 0.04, color: Colors.red),);
        }
  }
    List<Widget> pages = [
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("CURRENTLY", style: TextStyle(fontSize: fontTextSize)),
            (region == null ?
              const Text("NAO ACHEI O DISCO VOADOR") : 
              FutureBuilder<Widget>(
                future: getCurrentWeatherRegion(region!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: TextStyle(fontSize: size * 0.04, color: Colors.red),
                    );
                  } else {
                    return snapshot.data ?? const SizedBox(); // Widget vazio se o snapshot.data for nulo
                  }
                },
              ) 
            )
          ],
        )
      ),
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("TODAY", style: TextStyle(fontSize: fontTextSize)),
            (region == null ?
              const Text("achei o disco voador") :
              const Text("NAO ACHEI O DISCO VOADOR")
            )
          ],
        ) 
      ),
      Center(child: 
        Column(mainAxisAlignment: 
          MainAxisAlignment.center, 
          children: [
            Text("WEEKLY", style: TextStyle(fontSize: fontTextSize)),
            (region == null ?
              const Text("achei o disco voador") :
              const Text("NAO ACHEI O DISCO VOADOR")
            )
          ],
        )
      ),
    ];

    return  PageView(
      controller: _pageController,
      onPageChanged: _selectPage,
      children: pages,
    );
  }
}