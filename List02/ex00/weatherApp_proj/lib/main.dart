import 'package:flutter/material.dart';
import 'SearchFieldBar.dart';
import 'WeatherNavBar.dart';
import 'WeatherPages.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(WeatherApp());
}

class StateWeatherApp extends State<WeatherApp>{
  int _selectedIndex = 0;
  String? searchText;
  final PageController _pageController = PageController();

  Future<void> _determinePositionInit() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      searchText = 'Location services disabled.';
    });
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        searchText = 'Location permissions have been denied';
      });
      return ;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      searchText = 'Location permissions are permanently denied, we cannot request permissions.';
    });
    return ;
  }

  final teste = await Geolocator.getCurrentPosition();
  setState(() {
    searchText = 'Latitude: ${teste.latitude.toString()} Longitude: ${teste.longitude.toString()}';
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

  void updateSearchText(String newText){
    setState(() {
      searchText = newText;
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
            child: SizedBox(width: widthSearchField, child: SearchFieldBar(updateSearchText),) ,
          ),
        ),
        body: WeatherPages(nextPageWeather, _pageController, searchText),
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
