class InitMedication {
  int id;
  // int medicineId;
  String name;

  InitMedication(
    this.id,
    // this.medicineId,
    this.name,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inID': id,
      // 'inMedicineID': medicineId,
      'stMedicineName': name,
    };
    return map;
  }

  InitMedication.fromMap(Map<String, dynamic> map)
      : id = map['inID'] as int,
        // medicineId = map['inMedicineID'] as int,
        name = map['stMedicineName'] as String;
}
