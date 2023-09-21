import 'dart:convert';

import 'package:weather/data/http/exceptions.dart';
import 'package:weather/data/models/regionModel.dart';
import '../http/http_client.dart';

abstract class IRegionRepository {
  Future<List<String>> getRegion(String searchText);
}

class RegionRepository implements IRegionRepository{
  final HttpRepository client;

  RegionRepository({required this.client});

  @override
  Future<List<String>> getRegion(String searchText) async {
     if (searchText.isEmpty || searchText.length < 3 || searchText.length > 12) {
      return [];
    }
    const String domain = "https://geocoding-api.open-meteo.com/v1/search?";
    const String nameParam = "name=";
    const String countParam = "count=5";
    const String languageParam = "language=pt";
    const String formatParam = "format=json";


    final response = await client.get(
      url: "$domain$nameParam$searchText&$countParam&$languageParam&$formatParam"
    );

    if(response.statusCode == 200){
      final List<RegionModel> regions = [];
      final body =  jsonDecode(response.body);
      body["results"].map((item){
        final regionModel = RegionModel.fromMap(item);
        regions.add(regionModel);
      }).toList();

      List<String> cities = regions.map((result) {
        return '${result.name} - ${result.region} - ${result.country}';
      }).toList();
      return cities;
    } else if(response.statusCode == 404){
      throw NotFoundException("A url informada não é valida");
    } else {
      throw Exception("NÃO FOI POSSIVEL CARREGAR AS REGIÕES.");
    }
  }

}