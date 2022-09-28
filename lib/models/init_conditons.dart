class InitConditions {
  int id;
  // int conditionId;
  String name;
  String images;

  InitConditions(
    this.id,
    // this.conditionId,
    this.name,
    this.images,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inID': id,
      // 'inConditionID': conditionId,
      'stConditionName': name,
      'stConditionImage': images,
    };
    return map;
  }

  InitConditions.fromMap(Map<String, dynamic> map)
      : id = map['inID'] as int,
        // conditionId = map['inConditionID'] as int,
        name = map['stConditionName'] as String,
        images = map['stConditionImage'] as String;
}
