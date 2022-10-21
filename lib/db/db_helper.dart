import 'dart:async';

import 'package:hyd_initial_data_loading/models/init_conditons.dart';
import 'package:hyd_initial_data_loading/models/init_medicines.dart';

import '../models/condition.dart';
import '../models/medication.dart';
import '../models/unwell_list.dart';
import '../models/weekly_and_monthly_status.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'HYD_STORED_DATA.db');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print('Db Initialization');
    return db;
  }

  _onCreate(Database db, int version) async {
    print('_onCreate is happening');
    await db.execute('CREATE TABLE tblUsers('
        'inUserId INTEGER PRIMARY KEY,'
        'stEmail TEXT,'
        'stNickName TEXT,'
        'dcAge INTEGER,'
        'inGender INTEGER,'
        'pinCode TEXT,'
        'dtModificationDate NUMERIC,'
        'dtCreationDate TEXT,'
        'inRegistrationMedia INTEGER,flgIsLoggedIn INTEGER)');

    await db.execute('CREATE TABLE tblUserConditions('
        'inUserConditionID INTEGER PRIMARY KEY,'
        'inUserId INTEGER,'
        'stConditionThatAffect TEXT)');

    await db.execute('CREATE TABLE tblUserMedicines('
        'inUserMedicineID INTEGER PRIMARY KEY,'
        'inUserId INTEGER,'
        'stMedicineName TEXT)');

    await db.execute('CREATE TABLE tblConditions('
        'inID INTEGER PRIMARY KEY,'
        // 'inConditionID INTEGER,'
        'stConditionName TEXT,'
        'stConditionImage TEXT)');

    print('tblConditionIsCreated');

    await db.execute('CREATE TABLE tblMedicines('
        'inID INTEGER PRIMARY KEY,'
        // 'inMedicineID INTEGER,'
        'stMedicineName TEXT)');

    await db.execute('CREATE TABLE tblHealthReport('
        'inHealthReportId INTEGER PRIMARY KEY,'
        'inUserId INTEGER,'
        'inHealthStatus INTEGER,'
        'dtStatusDate INTEGER,'
        'inBodySide INTEGER,'
        'stBodyPartNames TEXT,'
        'stConditions TEXT,'
        'stMedications TEXT,'
        'stNote TEXT,'
        'dtCreationDate INTEGER,'
        'inPainLevelMin INTEGER,'
        'inPainLevelMax INTEGER)');

    await db.execute('CREATE TABLE tblUnwellDefaultList('
        'inUnwellId INTEGER PRIMARY KEY,'
        // 'stEmail TEXT,'
        'stConditonName TEXT,'
        // 'inConditionId INTEGER,'
        'stImageName TEXT)');

    await db.execute('CREATE TABLE tblWeeklyStatus('
        'weekDaysId INTEGER PRIMARY KEY,'
        'stEmail TEXT,'
        'stDay TEXT,'
        'stMonth TEXT,'
        'inHealthStatus INTEGER,'
        'stWeekDay TEXT,'
        'inPainLevel INTEGER)');
  }

  //==============================================================
  //===== initial conditions list

  Future<int> insertInitialConditions(InitConditions conditions) async {
    var dbClient = await db;
    final insertedId = await dbClient.insert(
      'tblConditions',
      conditions.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  Future<List<InitConditions>> getInitialCondition() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblConditions',
      columns: [
        'inID',
        // 'inConditionID',
        'stConditionName',
        'stConditionImage',
      ],
      // orderBy: "inConditionID ASC",
      // where: 'stEmail = ? ',
      // whereArgs: [stEmail],
    );
    List<InitConditions> condtionList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        condtionList.add(InitConditions.fromMap(maps[i]));
      }
    }
    return condtionList;
  }

  Future<int> deleteAllCondition() async {
    var dbClient = await db;
    return dbClient.rawDelete("DELETE FROM tblConditions");
  }

  //=== End Conditions List

  //=======================================================================

  //==== Initial Medicines List:

  Future<int> insertInitialMedicines(InitMedication medicines) async {
    var dbClient = await db;
    final insertedId = await dbClient.insert(
      'tblMedicines',
      medicines.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  Future<List<InitMedication>> getInitialMedicines() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblMedicines',
      columns: [
        'inID',
        'stMedicineName',
      ],
      // orderBy: "inConditionID ASC",
      // where: 'stEmail = ? ', inMedicineID stMedicineName
      // whereArgs: [stEmail],
    );
    List<InitMedication> medicinesList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        medicinesList.add(InitMedication.fromMap(maps[i]));
      }
    }

    return medicinesList;
  }

  //===== End Medicines List

  //===== Start User Table Insert, Update, Select ===

  // Future<Users> addUser(Users user) async {
  //   var dbClient = await db;
  //   user.id = await dbClient.insert('tblUsers', user.toMap());
  //   return user;
  // }

  // Future<int> insertUser(Users users) async {
  //   var dbClient = await db;
  //   final insertedId = await dbClient.insert(
  //     'tblUsers',
  //     users.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return insertedId;
  // }

  // Future<List<Users>> getUser() async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query('tblUsers', columns: [
  //     'inUserId',
  //     'stEmail',
  //     'stNickName',
  //     'dcAge',
  //     'inGender',
  //     'pinCode',
  //     'dtModificationDate',
  //     'dtCreationDate',
  //     'inRegistrationMedia',
  //     'flgIsLoggedIn'
  //   ]);
  //   List<Users> users = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       users.add(Users.fromMap(maps[i]));
  //     }
  //   }
  //   return users;
  // }

  // Future<Users> getUserIdByEmailId(String fsEmail) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblUsers',
  //     columns: [
  //       'inUserId',
  //       'stEmail',
  //       'stNickName',
  //       'dcAge',
  //       'inGender',
  //       'pinCode',
  //       'dtModificationDate',
  //       'dtCreationDate',
  //       'inRegistrationMedia'
  //     ],
  //     where: 'stEmail = ?',
  //     whereArgs: [fsEmail],
  //   );
  //   List<Users> users = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       users.add(Users.fromMap(maps[i]));
  //     }
  //   }
  //   if (users.length > 0) {
  //     return users.first;
  //   } else
  //     return null;
  // }

  // Future<int> updateUser(Users user) async {
  //   var dbClient = await db;
  //   return await dbClient.update(
  //     'tblUsers',
  //     user.toMap(),
  //     where: 'inUserId = ?',
  //     whereArgs: [user.id],
  //   );
  // }

  //===== End User Table Insert, Update, Select ===

  //===== Start Condition Table Insert, Update, Select ===

  // Future<int> addCondition(Conditions conditions) async {
  //   var dbClient = await db;
  //   final insertedId = await dbClient.insert(
  //     'tblUserConditions',
  //     conditions.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return insertedId;
  // }

  // Future<List<Conditions>> getCondition(int fiUserId) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblUserConditions',
  //     columns: [
  //       'inConditionThatAffect',
  //     ],
  //     where: 'inUserId = ?',
  //     whereArgs: [fiUserId],
  //   );
  //   List<Conditions> userConditions = [];
  //   if (maps.isNotEmpty) {
  //     for (int i = 0; i < maps.length; i++) {
  //       userConditions.add(Conditions.fromMap(maps[i]));
  //     }
  //   }
  //   return userConditions;
  // }

  // Future<int> deleteCondition(int fiUserId) async {
  //   var dbClient = await db;
  //   return await dbClient.delete(
  //     'tblUserConditions',
  //     where: 'inUserId = ?',
  //     whereArgs: [fiUserId],
  //   );
  // }

  // //=== Start Medication Insert, Select and Delete

  // Future<int> addMedication(UserMedication userMedication) async {
  //   var dbClient = await db;
  //   final insertedId = await dbClient.insert(
  //     'tblUserMedicines',
  //     userMedication.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return insertedId;
  // }

  // Future<List<Medication>> getMedication(int fiUserId) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblUserMedicines',
  //     columns: [
  //       'inMedicineID',
  //     ],
  //     where: 'inUserId = ?',
  //     whereArgs: [fiUserId],
  //   );
  //   List<Medication> userMedication = [];
  //   if (maps.isNotEmpty) {
  //     for (int i = 0; i < maps.length; i++) {
  //       userMedication.add(Medication.fromMap(maps[i]));
  //     }
  //   }
  //   return userMedication;
  // }

  // Future<int> deleteMedication(int fiUserId) async {
  //   var dbClient = await db;
  //   return await dbClient.delete(
  //     'tblUserMedicines',
  //     where: 'inUserId = ?',
  //     whereArgs: [fiUserId],
  //   );
  // }

  // //===== Getting email only ===

  // Future<int> addEmail(UserEmail userEmail) async {
  //   var dbClient = await db;
  //   final insertedId = await dbClient.insert(
  //     'tblEmail',
  //     userEmail.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return insertedId;
  // }

  //===== Updating Email table ===

  // Future<int> updateEmail(UserEmail userEmail) async {
  //   var dbClient = await db;
  //   return await dbClient.update(
  //     'tblEmail',
  //     userEmail.toMap(),
  //   );
  // }

  // Future<List<UserEmail>> getUserEmail() async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblEmail',
  //     columns: [
  //       'stEmail',
  //     ],
  //   );
  //   List<UserEmail> userEmail = [];
  //   if (maps.isNotEmpty) {
  //     for (int i = 0; i < maps.length; i++) {
  //       userEmail.add(UserEmail.fromMap(maps[i]));
  //     }
  //   }
  //   return userEmail;
  // }

  //===== Health Update DB Insert , Update , Select ===

  // Future<int> insertHealthReport(HealthReport healthReport) async {
  //   var dbClient = await db;
  //   final insertedHealthId = await dbClient.insert(
  //     'tblHealthReport',
  //     healthReport.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return insertedHealthId;
  // }

  // Future<int> updateHealthReport(HealthReport healthReport) async {
  //   var dbClient = await db;
  //   return await dbClient.update(
  //     'tblHealthReport',
  //     healthReport.toMap(),
  //     where: 'inHealthReportId = ?',
  //     whereArgs: [healthReport.id],
  //   );
  // }

  // Future<List<HealthReport>> getHealthReport() async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query('tblHealthReport', columns: [
  //     'inHealthReportId',
  //     'inUserId',
  //     'inHealthStatus',
  //     'inPainRating',
  //     'dtStatusDate',
  //     'inBodyPart',
  //     'stBodyPartNames',
  //     'inConditionId',
  //     'stMedicationIds',
  //     'stNote',
  //     'dtCreationDate',
  //     'inPainLevelMax',
  //     'inPainLevelMin',
  //   ]);
  //   List<HealthReport> _healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       _healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }
  //   return _healthReport;
  // }

  // Future<HealthReport> getHealthReportLatestEntry(
  //     int inUserId, int dtCreationDate) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblHealthReport',
  //     orderBy: "inHealthReportId DESC",
  //     limit: 1,
  //     where: 'inUserId = ? and dtCreationDate = ?',
  //     whereArgs: [inUserId, dtCreationDate],
  //   );
  //   List<HealthReport> healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }
  //   if (healthReport.length > 0) {
  //     return healthReport.first;
  //   } else
  //     return null;
  // }

  // Future<HealthReport> getHealthReportByUserId(
  //     int inUserId, int dtCreationDate) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblHealthReport',
  //     columns: [
  //       'inHealthReportId',
  //       'inUserId',
  //       'inHealthStatus',
  //       'inPainRating',
  //       'dtStatusDate',
  //       'inBodyPart',
  //       'stBodyPartNames',
  //       'inConditionId',
  //       'stMedicationIds',
  //       'stNote',
  //       'dtCreationDate',
  //       'inPainLevelMax',
  //       'inPainLevelMin',
  //     ],
  //     where: 'inUserId = ? and dtCreationDate = ?',
  //     whereArgs: [inUserId, dtCreationDate],
  //   );
  //   List<HealthReport> healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }
  //   if (healthReport.length > 0) {
  //     return healthReport.first;
  //   } else
  //     return null;
  // }

  // Future<List<HealthReport>> getUnwellHealthReportByUserId(int inUserId) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblHealthReport',
  //     columns: [
  //       'inHealthReportId',
  //       'inUserId',
  //       'inHealthStatus',
  //       'inPainRating',
  //       'dtStatusDate',
  //       'inBodyPart',
  //       'stBodyPartNames',
  //       'inConditionId',
  //       'stMedicationIds',
  //       'stNote',
  //       'dtCreationDate',
  //       'inPainLevelMax',
  //       'inPainLevelMin',
  //     ],
  //     orderBy: "inHealthReportId DESC",
  //     limit: 8,
  //     where: 'inUserId = ? and inHealthStatus=2',
  //     whereArgs: [inUserId],
  //   );
  //   List<HealthReport> healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }

  //   return healthReport;
  // }

  // Future<List<HealthReport>> getHealthReportAllByUserId(int inUserId) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblHealthReport',
  //     columns: [
  //       'inHealthReportId',
  //       'inUserId',
  //       'inHealthStatus',
  //       'inPainRating',
  //       'dtStatusDate',
  //       'inBodyPart',
  //       'stBodyPartNames',
  //       'inConditionId',
  //       'stMedicationIds',
  //       'stNote',
  //       'dtCreationDate',
  //       'inPainLevelMax',
  //       'inPainLevelMin',
  //     ],
  //     where: 'inUserId = ? ',
  //     whereArgs: [inUserId],
  //   );
  //   List<HealthReport> healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }

  //   return healthReport;
  // }

  // Future<HealthReport> getHealthReportByConditionId(int fiConditionId) async {
  //   var dbClient = await db;
  //   List<Map> maps = await dbClient.query(
  //     'tblHealthReport',
  //     columns: [
  //       'inHealthReportId',
  //       'inUserId',
  //       'inHealthStatus',
  //       'inPainRating',
  //       'dtStatusDate',
  //       'inBodyPart',
  //       'stBodyPartNames',
  //       'inConditionId',
  //       'stMedicationIds',
  //       'stNote',
  //       'dtCreationDate',
  //       'inPainLevelMax',
  //       'inPainLevelMin',
  //     ],
  //     where: 'inConditionId = ? ',
  //     whereArgs: [fiConditionId],
  //   );
  //   List<HealthReport> healthReport = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       healthReport.add(HealthReport.fromMap(maps[i]));
  //     }
  //   }
  //   if (healthReport.length > 0) {
  //     return healthReport.first;
  //   } else
  //     return null;
  // }
  //===== Default Unwell List ===

  Future<int> insertDefaultUnwellList(UnwellList unwellList) async {
    var dbClient = await db;
    final insertedId = await dbClient.insert(
      'tblUnwellDefaultList',
      unwellList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  Future<int> deleteDefaultUnwellList() async {
    var dbClient = await db;
    return await dbClient.rawDelete(
      'DELETE FROM tblUnwellDefaultList WHERE inUnwellId in (SELECT inUnwellId FROM tblUnwellDefaultList WHERE inUnwellId > 1 LIMIT 1 )',
      // 'tblUnwellDefaultList where (Select * from user where inUnwellId > 1 limit 1)'
      // where: 'stConditonName !=? and inUnwellId > 1',
      // whereArgs: ['Other'],
    );
  }

  Future<int> deleteDefaultUnwellListSelectedRow(
      String stConditionName, String stEmail) async {
    var dbClient = await db;
    return await dbClient.rawDelete(
      //'DELETE FROM tblUnwellDefaultList WHERE stConditonName = ? and stEmail = ?',
      //[stConditionName,stEmail],
      'DELETE FROM tblUnwellDefaultList WHERE stConditonName = ?',
      [stConditionName],
    );
  }

  Future<int> deleteAllDefaultUnwellCondition() async {
    var dbClient = await db;
    return dbClient.rawDelete("DELETE FROM tblUnwellDefaultList");
  }

  Future<List<UnwellList>> getDefaultUnwellList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblUnwellDefaultList',
      columns: [
        'inUnwellId',
        // 'stEmail',
        'stConditonName',
        // 'inConditionId',
        'stImageName',
      ],
      orderBy: "inUnwellId DESC",
      // where: 'stEmail = ? ',
      // whereArgs: [stEmail],
    );
    List<UnwellList> unwellList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        unwellList.add(UnwellList.fromMap(maps[i]));
      }
    }

    return unwellList;
  }

  Future<UnwellList> getDefaultUnwellListByConditionName(
      String stConditionName) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblUnwellDefaultList',
      where: 'stConditonName = ?',
      whereArgs: [stConditionName],
    );
    List<UnwellList> unwellList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        unwellList.add(UnwellList.fromMap(maps[i]));
      }
    }
    if (unwellList.length > 0) {
      return unwellList.first;
    } else
      return null;
  }

  //===== Start Weekly Table Inser , Update , Select ===

  Future<int> insertWeeklyHealthStatus(
      WeeklyAndMonthlyStatus weeklyStatus) async {
    var dbClient = await db;
    final insertedId = await dbClient.insert(
      'tblWeeklyStatus',
      weeklyStatus.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  Future<int> updateWeeklyHealthStatus(
      WeeklyAndMonthlyStatus weeklyStatus) async {
    var dbClient = await db;
    return await dbClient.update(
      'tblWeeklyStatus',
      weeklyStatus.toMap(),
      where: 'stDay = ? and stMonth = ? and stEmail = ?',
      whereArgs: [
        weeklyStatus.stDay,
        weeklyStatus.stMonth,
        weeklyStatus.stEmail
      ],
    );
  }

  Future<List<WeeklyAndMonthlyStatus>> getWeeklyHealthStatus(
      String stEmail) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblWeeklyStatus',
      columns: [
        'weekDaysId',
        'stEmail',
        'stDay',
        'stMonth',
        'inHealthStatus',
        'stWeekDay',
        'inPainLevel',
      ],
      distinct: true,
      orderBy: "weekDaysId DESC",
      limit: 7,
      where: 'stEmail = ? ',
      whereArgs: [stEmail],
    );
    List<WeeklyAndMonthlyStatus> weeklyStatus = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        weeklyStatus.add(WeeklyAndMonthlyStatus.fromMap(maps[i]));
      }
    }

    return weeklyStatus;
  }

  Future<List<WeeklyAndMonthlyStatus>> getMonthlyHealthStatus() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblWeeklyStatus',
      columns: [
        'weekDaysId',
        'stEmail',
        'stDay',
        'stMonth',
        'inHealthStatus',
        'stWeekDay',
        'inPainLevel',
      ],
      distinct: true,
      orderBy: "weekDaysId DESC",
      limit: 30,
      // where: 'stEmail = ? ',
      // whereArgs: [stEmail],
    );
    List<WeeklyAndMonthlyStatus> monthlyStatus = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        monthlyStatus.add(WeeklyAndMonthlyStatus.fromMap(maps[i]));
      }
    }

    return monthlyStatus;
  }

  Future<WeeklyAndMonthlyStatus> getWeeklyHealthStatusByDay(
      String stDay, String stMonth, String stEmail) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      'tblWeeklyStatus',
      where: 'stDay = ? and stMonth = ? and stEmail = ?',
      whereArgs: [stDay, stMonth, stEmail],
    );
    List<WeeklyAndMonthlyStatus> weeklyStatus = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        weeklyStatus.add(WeeklyAndMonthlyStatus.fromMap(maps[i]));
      }
    }
    if (weeklyStatus.length > 0) {
      return weeklyStatus.first;
    } else
      return null;
  }

  Future<WeeklyAndMonthlyStatus> getLastUpdatedWeeklyHealthStatus() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      'SELECT * FROM tblWeeklyStatus ORDER BY weekDaysId DESC LIMIT 1',
    );
    List<WeeklyAndMonthlyStatus> weeklyStatus = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        weeklyStatus.add(WeeklyAndMonthlyStatus.fromMap(maps[i]));
      }
    }
    if (weeklyStatus.length > 0) {
      return weeklyStatus.first;
    } else
      return null;
  }

  //===== End User Table Insert, Update, Select ===

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
