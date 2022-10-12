import 'package:netflix/model/person.dart';

class PersonResponse {
  late List<Person> persons;
  late String error;

  PersonResponse(this.persons, this.error);

  PersonResponse.fromJson(Map<String, dynamic> json)
      : persons = (json["results"] as List)
      .map((i) => Person.fromJson(i))
      .toList(),
        error = " ";

  PersonResponse.withError(String errorValue)
      : persons = [],
        error = errorValue;
}