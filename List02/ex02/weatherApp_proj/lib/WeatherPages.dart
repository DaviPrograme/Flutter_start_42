import 'package:flutter/material.dart';
import './data/models/regionModel.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';


class WeatherPages extends StatelessWidget{
  final void Function(int) _selectPage;
  final RegionModel? region;
  final PageController _pageController;

  String translateSingleForecast(String weatherCode) {
  const Map<String, String> weatherCodes = {
    "0": 'Clear sky',
    "1": 'Mainly clear',
    "2": 'Partly cloudy',
    "3": 'Overcast',
    "45": 'Fog',
    "48": 'Depositing rime fog',
    "51": 'Drizzle: Light Intensity',
    "53": 'Drizzle: Moderate Intensity',
    "55": 'Drizzle: Intense',
    "56": 'Freezing Drizzle: Light Intensity',
    "57": 'Freezing Drizzle: Intense',
    "61": 'Rain: Slight intensity',
    "63": 'Rain: Moderate',
    "65": 'Rain: Heavy',
    "66": 'Freezing Rain: Light Intensity',
    "67": 'Freezing Rain: Heavy',
    "71": 'Snow fall: Slight',
    "73": 'Snow fall: Moderate',
    "75": 'Snow fall: Heavy',
    "77": 'Snow grains',
    "80": 'Rain showers: Slight Intensity',
    "81": 'Rain showers: Moderate',
    "82": 'Rain showers: Violent',
    "85": 'Snow showers: slight',
    "86": 'Snow showers: heavy',
    "95": 'Thunderstorm: Slight or Moderate',
    "96": 'Thunderstorm with slight hail',
    "99": 'Thunderstorm with heavy hail',
  };

  return weatherCodes[weatherCode] ?? 'Unknown';
}

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
                AutoSizeText(translateSingleForecast(body["current_weather"]["weathercode"].toString()),
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.04),
                ),
                AutoSizeText("${body["current_weather"]["windspeed"].toString()} Km/h",
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
              const Text("") :
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