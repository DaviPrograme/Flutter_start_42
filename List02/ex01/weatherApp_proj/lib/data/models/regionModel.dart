class RegionModel {
  final String name;
  final String admin1;
  final String country;
  final String countryCode;

  RegionModel({
    required this.name,
    required this.admin1,
    required this.country,
    required this.countryCode,
  });

  factory RegionModel.fromMap(Map<String, dynamic> map){
    return RegionModel(name: map['name'], admin1: map['admin1'], country: map['country'], countryCode: map['country_code']);
  }
}