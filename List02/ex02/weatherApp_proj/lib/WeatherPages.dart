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
        final response = await regionRepository.callAPIWeather(region, "current_weather=true");
        final body = jsonDecode(response.body);
        if(response.statusCode == 200){
            return Column(
              children: [
                AutoSizeText("${region.name}, ${region.region}, ${region.country}",
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

    Future<Widget> getTodayWeatherRegion(RegionModel region) async {
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPIWeather(region, "hourly=temperature_2m,weathercode,windspeed_10m&timezone=GMT");
        final body = jsonDecode(response.body);
        List<String> time = List<String>.from(body['hourly']['time'].take(24));
        List<double> temperature = List<double>.from(body['hourly']['temperature_2m'].take(24));
        List<double> windspeed = List<double>.from(body['hourly']['windspeed_10m'].take(24));
        List<int> weathercode = List<int>.from(body['hourly']['weathercode'].take(24));
        List<DataColumn> columnList = const [
          DataColumn(label: Text("time")),
          DataColumn(label: Text("ºC")),
          DataColumn(label: Text("wind")),
          DataColumn(label: Text("weather")),
        ];
        List<DataRow> rowsList = [];

        for(int index = 0; index < time.length; ++index){
          rowsList.add(
            DataRow(cells: [
              DataCell(Text(time[index].split("T")[1])),
              DataCell(Text(temperature[index].toString())),
              DataCell(Text("${windspeed[index].toString()} km")),
              DataCell(Text(translateSingleForecast(weathercode[index].toString()))),
            ])
          );
        }
        if(response.statusCode == 200){
            return Column(
              children: [
                AutoSizeText("${region.name}, ${region.region}, ${region.country}",
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
                DataTable(
                  columns: columnList,
                  rows: rowsList)
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


    Future<Widget> getWeeklyWeatherRegion(RegionModel region) async {
      try{
        RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
        final response = await regionRepository.callAPIWeather(region, "daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT&current_weather=true");
        final body = jsonDecode(response.body);
        List<String> time = List<String>.from(body['daily']['time']);
        List<double> max = List<double>.from(body['daily']['temperature_2m_max']);
        List<double> min = List<double>.from(body['daily']['temperature_2m_min']);
        List<int> weathercode = List<int>.from(body['daily']['weathercode']);
        List<DataColumn> columnList = const [
          DataColumn(label: Text("time")),
          DataColumn(label: Text("min")),
          DataColumn(label: Text("max")),
          DataColumn(label: Text("weather")),
        ];
        List<DataRow> rowsList = [];

        for(int index = 0; index < time.length; ++index){
          rowsList.add(
            DataRow(cells: [
              DataCell(Text(time[index])),
              DataCell(Text(min[index].toString())),
              DataCell(Text(max[index].toString())),
              DataCell(Text(translateSingleForecast(weathercode[index].toString()))),
            ])
          );
        }
        if(response.statusCode == 200){
            return Column(
              children: [
                AutoSizeText("${region.name}, ${region.region}, ${region.country}",
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
                DataTable(
                  columns: columnList,
                  rows: rowsList)
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
      Center( child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(child:
        Column(mainAxisAlignment: 
          MainAxisAlignment.center,
          children: [
            Text("TODAY", style: TextStyle(fontSize: fontTextSize)),
            (region == null ?
              const Text("") :
               FutureBuilder<Widget>(
                future: getTodayWeatherRegion(region!),
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
              Text("WEEKLY", style: TextStyle(fontSize: fontTextSize)),
              (region == null ?
                const Text("") :
                FutureBuilder<Widget>(
                  future: getWeeklyWeatherRegion(region!),
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