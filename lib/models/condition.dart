import 'package:flutter/cupertino.dart';

class ConditionList {
  final List<Conditions> conditions;

  ConditionList({
    this.conditions,
  });

  factory ConditionList.fromJson(List<dynamic> parsedJson) {
    List<Conditions> conditions = new List<Conditions>();
    conditions = parsedJson.map((i) => Conditions.fromJson(i)).toList();

    return new ConditionList(conditions: conditions);
  }
}

class Conditions {
  int id;
  String name;
  String images;

  Conditions({
    this.id,
    this.name,
    this.images,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inConditionID': id,
      'stConditionName': name,
      'stConditionImage': images,
    };
    return map;
  }

  Conditions.fromMap(Map<String, dynamic> map)
      : id = map['inConditionThatAffect'] as int;

  factory Conditions.fromJson(Map<String, dynamic> parsedJson) {
    return Conditions(
        id: parsedJson['id'],
        name: parsedJson['name'],
        images: parsedJson['images']);
  }
}
