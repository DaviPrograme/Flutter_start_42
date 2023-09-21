class RegionModel {
  final String name;
  final String region;
  final String country;
  final String countryCode;

  RegionModel({
    required this.name,
    required this.region,
    required this.country,
    required this.countryCode,
  });

  factory RegionModel.fromMap(Map<String, dynamic> map){
    final dynamic nameSelected = map['name'] ?? "unknow";
    final dynamic regionSelected = map['admin2'] ?? "unknow";
    final dynamic countrySelected = map['country'] ?? "unknow";
    return RegionModel(name: nameSelected, region: regionSelected, country: countrySelected, countryCode: map['country_code']);
  }
}