import 'dart:convert';

import 'package:weather/data/http/exceptions.dart';
import 'package:weather/data/models/regionModel.dart';
import '../http/http_client.dart';

abstract class IRegionRepository {
  Future<List<String>> getRegionsSuggestion(String searchText);
}

class RegionRepository implements IRegionRepository{
  final HttpRepository client;

  RegionRepository({required this.client});

  Future<dynamic> callAPIGeolocationName(String nameParam) {
    const String domain = "https://geocoding-api.open-meteo.com/v1/search?";
    const String nameQuery = "name=";
    const String languageQuery = "language=pt";
    const String formatQuery = "format=json";

    return client.get(
      url: "$domain$nameQuery$nameParam&$languageQuery&$formatQuery"
    );
  }

  List<RegionModel> convertAPIGeolocationNameResponseIntoListRegions(dynamic response, String regionParam, String countryParam, [int numberSuggestionsShow = 0]) {
    final List<RegionModel> regions = [];
    final body =  jsonDecode(response.body);
      body["results"].map((item){
        final regionModel = RegionModel.fromMap(item);
        regions.add(regionModel);
        if((regionParam.isNotEmpty && !regionModel.region.toLowerCase().contains(regionParam.toLowerCase())) ||
        (countryParam.isNotEmpty && !regionModel.country.toLowerCase().contains(countryParam.toLowerCase()))) {
          regions.removeLast();
        }
      }).toList();
      if(numberSuggestionsShow > 0 && regions.length > numberSuggestionsShow){
        regions.removeRange(numberSuggestionsShow, regions.length);
      }
    return regions;
  }

  Future<dynamic> callAPICurrentWeather(RegionModel region) {
    const String domain = "https://api.open-meteo.com/v1/forecast?";
    const String latitudeQuery = "latitude=";
    const String longitudeQuery = "longitude=";
    const String weatherQuery="current_weather=true";

    return client.get(
      url: "$domain$latitudeQuery${region.latitude}&$longitudeQuery${region.longitude}&$weatherQuery"
    );
  }

  @override
  Future<List<String>> getRegionsSuggestion(String searchText) async {
    List<String> params = searchText.split(",");
    String nameParam = params.isNotEmpty ? params[0].trim() : "";
    String regionParam = params.length >= 2 ? params[1].trim() : "";
    String countryParam = params.length >= 3 ? params[2].trim() : "";

    if (nameParam.isEmpty || nameParam.length < 3) {
      return [];
    }

    final response = await callAPIGeolocationName(nameParam);

    if(response.statusCode == 200){
      final List<RegionModel> regions = convertAPIGeolocationNameResponseIntoListRegions(response, regionParam, countryParam, 5);
      List<String> regionsSuggestions = regions.map((result) {
        return '${result.name}, ${result.region}, ${result.country}';
      }).toList();
      return regionsSuggestions;
    } else if(response.statusCode == 404){
      throw NotFoundException("URL not found.");
    } else {
      throw Exception("Unable to load region information.");
    }
  }

   Future<RegionModel> getRegionFocus(String searchText) async {
    List<String> params = searchText.split(",");
    String nameParam = params.isNotEmpty ? params[0].trim() : "";
    String regionParam = params.length >= 2 ? params[1].trim() : "";
    String countryParam = params.length >= 3 ? params[2].trim() : "";

    final response = await callAPIGeolocationName(nameParam);

    if(response.statusCode == 200){
      List<RegionModel> regions = convertAPIGeolocationNameResponseIntoListRegions(response, regionParam, countryParam, 1);
      if(regions.isEmpty){
        throw Exception("[GeolocationName]Region not found.");
      }
      return regions[0];
    } else if(response.statusCode == 404){
      throw NotFoundException("[GeolocationName]URL not found.");
    } else {
      throw Exception("[GeolocationName]Unable to load region information.");
    }
  }
}