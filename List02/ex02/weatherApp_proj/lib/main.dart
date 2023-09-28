import 'package:flutter/material.dart';
import 'SearchFieldBar.dart';
import 'WeatherNavBar.dart';
import 'WeatherPages.dart';
import './data/models/regionModel.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';

void main() {
  runApp(WeatherApp());
}

class StateWeatherApp extends State<WeatherApp>{
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Widget? contentPage;
  RegionModel? region;


      void searchRegion(String searchText) async {
        if(searchText.isEmpty){
          return;
        }
        try{
          RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
          RegionModel regionTemp = await regionRepository.getRegionFocus(searchText);
          setState(() {
            region = regionTemp;
          });
        } catch (e){
          setState(() {
            region = null;
          });
          print(e);
        }
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
            child: SizedBox(width: widthSearchField, child: SearchFieldBar(updateContentPage, searchRegion),) ,
          ),
        ),
        body: WeatherPages(nextPageWeather, _pageController, region),
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
