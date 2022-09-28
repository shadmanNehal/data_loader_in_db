class UnwellList {
  int id;
  // String stEmail;
  String stConditonName;
  String stImageName;

  UnwellList(
    this.id,
    // this.stEmail,
    this.stConditonName,
    this.stImageName,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inUnwellId': id,
      // 'stEmail': stEmail,
      'stConditonName': stConditonName,
      'stImageName': stImageName,
    };
    return map;
  }

  UnwellList.fromMap(Map<String, dynamic> map)
      : id = map['inUnwellId'] as int,
      //   stEmail = map['stEmail'] as String,
      stConditonName = map['stConditonName'] as String,
      stImageName = map['stImageName'] as String;
}
