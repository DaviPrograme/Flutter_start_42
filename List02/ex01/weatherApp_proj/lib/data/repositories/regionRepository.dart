import 'dart:convert';

import 'package:weather/data/http/exceptions.dart';
import 'package:weather/data/models/regionModel.dart';
import '../http/http_client.dart';

abstract class IRegionRepository {
  Future<List<RegionModel>> getRegion();
}

class RegionRepository implements IRegionRepository{
  final HttpRepository client;

  RegionRepository({required this.client});

  @override
  Future<List<RegionModel>> getRegion() async {
    final response = await client.get(
      url: "https://geocoding-api.open-meteo.com/v1/search?name=Paris&count=10&language=en&format=json"
    );

    if(response.statusCode == 200){
      final List<RegionModel> regions = [];
      final body =  jsonDecode(response.body);
      body["results"].map((item){
        final regionModel = RegionModel.fromMap(item);
        regions.add(regionModel);
      }).toList();
      return regions;
    } else if(response.statusCode == 404){
      throw NotFoundException("A url informada não é valida");
    } else {
      throw Exception("NÃO FOI POSSIVEL CARREGAR AS REGIÕES.");
    }
  }

}