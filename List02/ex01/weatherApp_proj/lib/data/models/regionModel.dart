class RegionModel {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  RegionModel({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude
  });

  factory RegionModel.fromMap(Map<String, dynamic> map){
    final dynamic nameSelected = map['name'] ?? "unknow";
    final dynamic regionSelected = map['admin1'] ?? "unknow";
    final dynamic countrySelected = map['country'] ?? "unknow";
    return RegionModel(
      name: nameSelected, 
      region: regionSelected, 
      country: countrySelected,
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}