class AllCountry {
  String name;
  int id;

  AllCountry({this.name, this.id});

  factory AllCountry.fromJson(Map<String, dynamic> json) {
    return AllCountry(
      name: json['name'],
      id: int.parse(json['id'].toString()),
    );
  }
}

class CountryList {
  List<AllCountry> countries = [];

  CountryList({this.countries});

  factory CountryList.fromJson(List<dynamic> json) {
    List<AllCountry> countryList;

    for(var i=0;i<json.length;i++){

      if(json[i]["name"]=="as-Sulaymaniyah"){
        json.first = json[i];

      }
     
      if(json[i]["name"]=="Iraq"){
        print("Get");

        json.first = json[i];
      }
    }

    countryList = json.map((i) => AllCountry.fromJson(i)).toList();

    return CountryList(countries: countryList);
  }
}
