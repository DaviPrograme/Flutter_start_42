import 'package:flutter/material.dart';
import 'SearchFieldBar.dart';
import 'WeatherNavBar.dart';
import 'WeatherPages.dart';
import './data/models/regionModel.dart';
import './data/repositories/regionRepository.dart';
import './data/http/http_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';


void main() {
  runApp(WeatherApp());
}

class StateWeatherApp extends State<WeatherApp>{
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  RegionModel? region;
  bool withoutGPSPermition = false;

  void setGpsPermitionStatus(bool status){
    setState(() {
      withoutGPSPermition = status;
    });
  }

  Future<void> _determinePositionInit() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      region = null;
      withoutGPSPermition = true;
    });
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        region = null;
        withoutGPSPermition = true;
      });
      return ;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      setState(() {
       region = null;
       withoutGPSPermition = true;
      });
    });
    return ;
  }

  final teste = await Geolocator.getCurrentPosition();
  setState(() {
     region = RegionModel(name: "Here", region: "", country: "", latitude: teste.latitude, longitude: teste.longitude);
  });
}

  @override
  void initState() {
    super.initState();
    _determinePositionInit();    
  }

  void searchRegion(String searchText) async {
    if(searchText.isEmpty){
      return;
    }
    try{
      RegionRepository regionRepository =  RegionRepository(client: HttpRepository());
      RegionModel regionTemp = await regionRepository.getRegionFocus(searchText);
      setState(() {
        withoutGPSPermition = false;
        region = regionTemp;
      });
    } catch (e){
      setState(() {
        withoutGPSPermition = false;
        region = null;
      });
      print(e);
    }
  }

  void setRegion(RegionModel newRegion){
    setState(() {
      region = newRegion;
    });
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
    double maxFont = 100;
    double minFont = 10;
    Widget? withoutGPSPermissionPage;

    if(withoutGPSPermition){
      withoutGPSPermissionPage = 
      AutoSizeText("App without access to the device's GPS",
        maxFontSize: maxFont,
        minFontSize: minFont,
        maxLines: 1,
        style: TextStyle(fontSize: size * 0.04, color: Colors.red)
      );
    } 

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("WEATHER 42", style: TextStyle(fontSize: fontTextSize),)
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(size * 0.07),
            child: SizedBox(width: widthSearchField, child: SearchFieldBar(setRegion, searchRegion, setGpsPermitionStatus),) ,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/fundoApp.jpg"), fit: BoxFit.fill)),
          child: 
            Container(
              color: const Color.fromRGBO(0, 0, 0, 0.55),
              height: double.infinity,
              child: WeatherPages(nextPageWeather, _pageController, region, withoutGPSPermissionPage)
            ),
          ),
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
