class TestMedicine {
  int id;
  String name;

  TestMedicine({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inID': id,
      'stMedicineName': name,
    };
    return map;
  }

  TestMedicine.fromMap(Map<String, dynamic> map)
      : id = map['inID'] as int,
        name = map['stMedicineName'] as String;
  
}
