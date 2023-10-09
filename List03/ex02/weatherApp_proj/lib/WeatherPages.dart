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
  final Widget? withoutGPSPermissionPage;

  String translateSingleForecastText(String weatherCode) {
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

  IconData translateSingleForecastIcon(String weatherCode) {
  const Map<String, IconData> weatherCodes = {
    "Clear sky": Icons.sunny,
    "Mainly clear": Icons.sunny,
    "Partly cloudy": Icons.wb_twighlight,
    "Overcast": Icons.cloud,
    "Fog": Icons.foggy,
    "Depositing rime fog": Icons.foggy,
    "Drizzle: Light Intensity": Icons.snowing,
    "Drizzle: Moderate Intensity": Icons.snowing,
    "Drizzle: Intense": Icons.snowing,
    "Freezing Drizzle: Light Intensity": Icons.snowing,
    "Freezing Drizzle: Intense": Icons.snowing,
    "Rain: Slight intensity": Icons.cloudy_snowing,
    "Rain: Moderate": Icons.cloudy_snowing,
    "Rain: Heavy": Icons.cloudy_snowing,
    "Freezing Rain: Light Intensity": Icons.cloudy_snowing,
    "Freezing Rain: Heavy": Icons.cloudy_snowing,
    "Snow fall: Slight": Icons.snowboarding,
    "Snow fall: Moderate": Icons.snowboarding,
    "Snow fall: Heavy": Icons.snowboarding,
    "Snow grains": Icons.snowboarding,
    "Rain showers: Slight Intensity": Icons.cloudy_snowing,
    "Rain showers: Moderate": Icons.cloudy_snowing,
    "Rain showers: Violent": Icons.cloudy_snowing,
    "Snow showers: slight": Icons.snowboarding,
    "Snow showers: heavy": Icons.snowboarding,
    "Thunderstorm: Slight or Moderate": Icons.thunderstorm,
    "Thunderstorm with slight hail": Icons.thunderstorm,
    "Thunderstorm with heavy hail": Icons.thunderstorm,
  };

  return weatherCodes[weatherCode] ?? Icons.block;
}


  WeatherPages(this._selectPage, this._pageController, this.region, this.withoutGPSPermissionPage);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double fontTextSize = size * 0.1;
    double maxFont = 100;
    double minFont = 10;
    

    Future<Widget> getCurrentWeatherRegion(RegionModel? region, Widget? gpsPermissionError) async {
      if(gpsPermissionError != null){
        return gpsPermissionError;
      }
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPIWeather(region!, "current_weather=true");
        final body = jsonDecode(response.body);
        if(response.statusCode == 200){
          String forecast = translateSingleForecastText(body["current_weather"]["weathercode"].toString());
            return Column(
              children: [
                AutoSizeText("${region.name}, ${region.country}",
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.05, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size * 0.09,),
                 AutoSizeText("${body["current_weather"]["temperature"].toString()}ºC",
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.15, color: Colors.white),
                ),
                SizedBox(height: size * 0.09,),
                AutoSizeText(forecast,
                  maxFontSize: maxFont,
                  minFontSize: minFont,
                  maxLines: 1,
                  style: TextStyle(fontSize: size * 0.06, color: Colors.white),
                ),              
                Icon(translateSingleForecastIcon(forecast), size: size * 0.3, color: Colors.orange,),
                SizedBox(height: size * 0.09,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wind_power, size: size * 0.08, color: Colors.orange,),
                    SizedBox(width: size * 0.05,),
                    AutoSizeText("${body["current_weather"]["windspeed"].toString()} Km/h",
                      maxFontSize: maxFont,
                      minFontSize: minFont,
                      maxLines: 1,
                      style: TextStyle(fontSize: size * 0.06, color: Colors.white),
                    ),
                  ],
                ),
                
              ],
            );
        } else if(response.statusCode == 404){
          throw Exception("URL not found.");
        } else {
          throw Exception("[${response.statusCode}] Unable to load region information.");
        }
        }catch(e){
            return Text("$e", style: TextStyle(fontSize: size * 0.04, color: Colors.red),);
        }
    }

    Future<Widget> getTodayWeatherRegion(RegionModel? region, Widget? gpsPermissionError) async {
      if(gpsPermissionError != null){
        return gpsPermissionError;
      }
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPIWeather(region!, "hourly=temperature_2m,weathercode,windspeed_10m&timezone=GMT");
        if(response.statusCode == 200){
          final body = jsonDecode(response.body);
          List<String> time = List<String>.from(body['hourly']['time'].take(24));
          List<double> temperature = List<double>.from(body['hourly']['temperature_2m'].take(24));
          List<double> windspeed = List<double>.from(body['hourly']['windspeed_10m'].take(24));
          List<int> weathercode = List<int>.from(body['hourly']['weathercode'].take(24));
          List<DataColumn> columnList = const [
            DataColumn(label: Text("time", style: TextStyle(color: Colors.white))),
            DataColumn(label: Text("ºC", style: TextStyle(color: Colors.white))),
            DataColumn(label: Text("wind", style: TextStyle(color: Colors.white))),
            DataColumn(label: Text("weather", style: TextStyle(color: Colors.white))),
          ];
          List<DataRow> rowsList = [];

          for(int index = 0; index < time.length; ++index){
            rowsList.add(
              DataRow(cells: [
                DataCell(Text(time[index].split("T")[1], style: const TextStyle(color: Colors.white))),
                DataCell(Text(temperature[index].toString(), style: const TextStyle(color: Colors.white))),
                DataCell(Text("${windspeed[index].toString()} km", style: const TextStyle(color: Colors.white))),
                DataCell(Text(translateSingleForecastText(weathercode[index].toString()), style: const TextStyle(color: Colors.white))),
              ])
            );
          }
          return
          Column(
            children: [
              AutoSizeText("${region.name}, ${region.region}, ${region.country}",
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: size * 0.04, color: Colors.white),
              ),
              AutoSizeText('Latitude: ${region.latitude} Longitude: ${region.longitude}',
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: size * 0.04, color: Colors.white),
              ),
              DataTable(
                columns: columnList,
                rows: rowsList)
            ],
          );
        } else if(response.statusCode == 404){
          throw Exception("URL not found.");
        } else {
          throw Exception("[${response.statusCode}] Unable to load region information.");
        }
        }catch(e){
            return Text(e.toString(), style: TextStyle(fontSize: size * 0.04, color: Colors.red),);
        }
    }


    Future<Widget> getWeeklyWeatherRegion(RegionModel? region, Widget? gpsPermissionError) async {
      if(gpsPermissionError != null){
        return gpsPermissionError;
      }
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPIWeather(region!, "daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT&current_weather=true");
        if(response.statusCode == 200){
          final body = jsonDecode(response.body);
          List<String> time = List<String>.from(body['daily']['time']);
          List<double> max = List<double>.from(body['daily']['temperature_2m_max']);
          List<double> min = List<double>.from(body['daily']['temperature_2m_min']);
          List<int> weathercode = List<int>.from(body['daily']['weathercode']);
          List<DataColumn> columnList = const [
            DataColumn(label: Text("time", style: TextStyle(color: Colors.white),)),
            DataColumn(label: Text("min", style: TextStyle(color: Colors.white),)),
            DataColumn(label: Text("max", style: TextStyle(color: Colors.white),)),
            DataColumn(label: Text("weather", style: TextStyle(color: Colors.white),)),
          ];
          List<DataRow> rowsList = [];

          for(int index = 0; index < time.length; ++index){
            rowsList.add(
              DataRow(cells: [
                DataCell(Text(time[index], style: const TextStyle(color: Colors.white),)),
                DataCell(Text(min[index].toString(), style: const TextStyle(color: Colors.white),)),
                DataCell(Text(max[index].toString(), style: const TextStyle(color: Colors.white),)),
                DataCell(Text(translateSingleForecastText(weathercode[index].toString()), style: const TextStyle(color: Colors.white),)),
              ])
            );
          }
          return
          Column(
            children: [
              AutoSizeText("${region.name}, ${region.region}, ${region.country}",
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: size * 0.04, color: Colors.white),
              ),
              AutoSizeText('Latitude: ${region.latitude} Longitude: ${region.longitude}',
                maxFontSize: maxFont,
                minFontSize: minFont,
                maxLines: 1,
                style: TextStyle(fontSize: size * 0.04, color: Colors.white),
              ),
              DataTable(
                columns: columnList,
                rows: rowsList
              )
            ],
          );
        } else if(response.statusCode == 404){
          throw Exception("URL not found.");
        } else {
          throw Exception("[${response.statusCode}] Unable to load region information.");
        }
        }catch(e){
            return Text(e.toString(), style: TextStyle(fontSize: size * 0.04, color: Colors.red),);
        }
    }

    Widget regionEmpty = AutoSizeText('Region not found.',
        maxFontSize: maxFont,
        minFontSize: minFont,
        maxLines: 1,
        style: TextStyle(fontSize: size * 0.1, color: Colors.red),
    );

    Widget buildCurrentlyPage(){
      Widget pageBase = 
      Center( child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (region == null && withoutGPSPermissionPage == null?
              regionEmpty :
              FutureBuilder<Widget>(
                future: getCurrentWeatherRegion(region, withoutGPSPermissionPage),
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
      );
      if(MediaQuery.of(context).orientation == Orientation.landscape){
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: pageBase
        );
      }
      return pageBase;
    }

    List<Widget> pages = [
      buildCurrentlyPage(),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(child:
        Column(mainAxisAlignment: 
          MainAxisAlignment.center,
          children: [
            Text("TODAY", style: TextStyle(fontSize: fontTextSize, color: Colors.white)),
            (region == null && withoutGPSPermissionPage == null?
              regionEmpty :
               FutureBuilder<Widget>(
                future: getTodayWeatherRegion(region, withoutGPSPermissionPage),
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
      ),
     SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WEEKLY", style: TextStyle(fontSize: fontTextSize, color: Colors.white)),
              (region == null && withoutGPSPermissionPage == null ?
                regionEmpty :
                FutureBuilder<Widget>(
                  future: getWeeklyWeatherRegion(region, withoutGPSPermissionPage),
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
      )
    ];

    return  PageView(
      controller: _pageController,
      onPageChanged: _selectPage,
      children: pages,
    );
  }
}