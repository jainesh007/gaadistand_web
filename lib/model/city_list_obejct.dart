class AllCities {
  String value;
  int key;

  AllCities({this.key, this.value});

  factory AllCities.fromJson(Map<String, dynamic> parsedJson) {
    return AllCities(
      value: parsedJson['value'] as String,
      key: parsedJson['key'],
    );
  }
}
