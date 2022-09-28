class MedicationList {
  final List<Medication> medication;

  MedicationList({
    this.medication,
  });

  factory MedicationList.fromJson(List<dynamic> parsedJson) {
    List<Medication> medication = new List<Medication>();
    medication = parsedJson.map((i) => Medication.fromJson(i)).toList();

    return new MedicationList(medication: medication);
  }
}

class Medication {
  int id;
  String name;

  Medication({
    this.id,
    this.name,
  });

  Medication.fromMap(Map<String, dynamic> map)
      : id = map['inMedicineID'] as int;

  factory Medication.fromJson(Map<String, dynamic> parsedJson) {
    return Medication(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
