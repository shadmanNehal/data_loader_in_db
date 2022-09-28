class WeeklyAndMonthlyStatus {
  int id;
  String stEmail;
  String stDay;
  String stMonth;
  int inHealthStatus;
  String stWeekDay;
  int inPainLevel;

  WeeklyAndMonthlyStatus(this.id, this.stEmail, this.stDay, this.stMonth,
      this.inHealthStatus, this.stWeekDay, this.inPainLevel);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'weekDaysId': id,
      'stEmail': stEmail,
      'stDay': stDay,
      'stMonth': stMonth,
      'inHealthStatus': inHealthStatus,
      'stWeekDay': stWeekDay,
      'inPainLevel': inPainLevel
    };
    return map;
  }

  WeeklyAndMonthlyStatus.fromMap(Map<String, dynamic> map)
      : id = map['weekDaysId'] as int,
        stEmail = map['stEmail'] as String,
        stDay = map['stDay'] as String,
        stMonth = map['stMonth'] as String,
        inHealthStatus = map['inHealthStatus'] as int,
        stWeekDay = map['stWeekDay'] as String,
        inPainLevel = map['inPainLevel'] as int;
}
