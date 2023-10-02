import 'package:flutter/material.dart';
import 'SearchFieldBar.dart';
import 'WeatherNavBar.dart';
import 'WeatherPages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(WeatherApp());
}

class StateWeatherApp extends State<WeatherApp>{
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Widget? contentPage;

  Future<void> _determinePositionInit() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      contentPage = const AutoSizeText('Location services are disabled.',
        maxFontSize: 30,
        minFontSize: 8,
        maxLines: 1,
        style: TextStyle(fontSize: 30, color: Colors.red),
      );
    });
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        contentPage = const AutoSizeText('Location permissions are denied',
          maxFontSize: 30,
          minFontSize: 8,
          maxLines: 1,
          style: TextStyle(fontSize: 30, color: Colors.red),
        );
      });
      return ;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      setState(() {
        contentPage = const AutoSizeText('Location permissions are permanently denied, we cannot request permissions.',
          maxFontSize: 30,
          minFontSize: 8,
          maxLines: 1,
          style: TextStyle(fontSize: 30, color: Colors.red),
        );
      });
    });
    return ;
  }

  final teste = await Geolocator.getCurrentPosition();
  setState(() {
     contentPage = 
      AutoSizeText('Latitude: ${teste.latitude.toString()} Longitude: ${teste.longitude.toString()}',
        maxFontSize: 30,
        minFontSize: 8,
        maxLines: 1,
        style: const TextStyle(fontSize: 30),
        );
  });
}

  @override
  void initState() {
    super.initState();
    _determinePositionInit();    
  }


  void nextPageWeather(int index){
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void jumpPageWeather(int index){
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void updateContentPage(Widget newContent){
    setState(() {
      contentPage = newContent;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){ 
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size = height < width ? height : width;
    double widthSearchField = width * 0.98;
    double fontTextSize = size * 0.05;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("WEATHER 42", style: TextStyle(fontSize: fontTextSize),)
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(size * 0.07),
            child: SizedBox(width: widthSearchField, child: SearchFieldBar(updateContentPage),) ,
          ),
        ),
        body: WeatherPages(nextPageWeather, _pageController, contentPage),
        bottomNavigationBar: WeatherNavBar(jumpPageWeather, _selectedIndex),
      ),
    );
  }
}

class WeatherApp extends StatefulWidget {
   @override
  StateWeatherApp createState() {
   return StateWeatherApp();
  }
}
