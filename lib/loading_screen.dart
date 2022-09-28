import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyd_initial_data_loading/db/db_helper.dart';
import 'package:hyd_initial_data_loading/models/init_conditons.dart';
import 'package:hyd_initial_data_loading/models/init_medicines.dart';
import 'package:path_provider/path_provider.dart';

import 'models/condition.dart';
import 'models/medication.dart';
import 'models/unwell_list.dart';
import 'models/weekly_and_monthly_status.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  DBHelper dbHelper;
  ConditionList conditionList;
  MedicationList medicationList;

  List<Conditions> _condition;
  List<Medication> _medication;

  ConditionList conditionList2;
  List<Conditions> _condtion2;

  MedicationList medicationList2;
  List<Medication> _medication2;

  Future<List<InitConditions>> GetConditionList;
  List<InitConditions> getConditionList;

  Future<List<InitMedication>> GetMedicinesList;
  List<InitMedication> getMedicinesList;

  Future<List<UnwellList>> GetUnwellList;
  List<UnwellList> getUnwellList;

  Future<List<WeeklyAndMonthlyStatus>> WeeklyAndMonthlyDefaultStatus;
  List<WeeklyAndMonthlyStatus> weeklyAndMonthlyDefaultStatus;
  bool flg = true;
  bool medBtn = false;
  bool conBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    Future.delayed(Duration.zero, () {
      this.BindCondition();
      this.BindMedication();
    });
    Future.delayed(Duration.zero, () {
      this.BindUnwellList();
      this.BindWeeklyMonthlyData();
      this.GetCondition();
      this.GetMedicines();
      flg = false;
    });
  }

  ///========= File Access from device

  void pickFiless(int num) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'json',
        ],
        allowMultiple: true);
    if (result == null) return;

    PlatformFile file = result.files.first;
    // viewFile(file);
    _read(file, num);
  }

  _read(PlatformFile file, int num) async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file1 = File(file.path);
      text = await file1.readAsString();
    } catch (e) {
      print(e);
      print("Couldn't read file");
    }
    var jsonResponse1 = json.decode(text);
    conditionList2 = ConditionList.fromJson(jsonResponse1);
    setState(() {
      _condtion2 = conditionList2.conditions;
    });
    var jsonResponse = json.decode(text);
    medicationList2 = MedicationList.fromJson(jsonResponse);
    setState(() {
      _medication2 = medicationList2.medication;
    });
    print(_condtion2.length);
    if (num == 1) {
      loadConditionToDB2();
    } else {
      loadMedicinesToDB2();
    }
  }

  //========== End file access

  //======= Condition storing in db using file access

  Future<int> saveInitialCondition2(int indexValue) async {
    setState(() {
      _condtion2;
    });
    print(
        'Condition Id: ${_condtion2[indexValue].id} and Name: ${_condtion2[indexValue].name}');
    int id = await dbHelper.insertInitialConditions(InitConditions(
      null,
      // _condtion2[indexValue].id,
      _condtion2[indexValue].name,
      _condtion2[indexValue].images,
    ));
    return id;
  }

  loadConditionToDB2() async {
    flg = false;
    for (int i = 0; i < _condtion2.length; i++) {
      await saveInitialCondition2(i);
    }
    conBtn = false;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoadingScreen(title: 'Loading data in db')));
  }

  //======== End condition storage using file access.

  //======== Medicines storing in db using file access

  Future<int> saveInitialMedicines2(int indexValue) async {
    setState(() {
      _medication2;
    });
    print(
        'Medicine Id: ${_medication2[indexValue].id} and Name: ${_medication2[indexValue].name}');
    int id = await dbHelper.insertInitialMedicines(
        InitMedication(null, _medication2[indexValue].name));
    return id;
  }

  loadMedicinesToDB2() async {
    for (int i = 0; i < _medication2.length; i++) {
      await saveInitialMedicines2(i);
    }
    medBtn = false;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoadingScreen(title: 'Hyd data loader')));
  }

  //====== End medicines storage using file access.

  //===== Condition with local db operations:
  // Future<int> saveInitialCondition(int indexValue) async {
  //   setState(() {
  //     _condition;
  //   });
  //   print(
  //       'Condition Id: ${_condition[indexValue].id} and Name: ${_condition[indexValue].name}');
  //   int id = await dbHelper.insertInitialConditions(InitConditions(
  //     null,
  //     // _condition[indexValue].id,
  //     _condition[indexValue].name,
  //     _condition[indexValue].images,
  //   ));
  //   return id;
  // }

  // loadConditionToDB() {
  //   for (int i = 0; i < _condition.length; i++) {
  //     saveInitialCondition(i);
  //   }
  // }

  GetCondition() {
    setState(() {
      GetConditionList = dbHelper.getInitialCondition();
    });
    getConditionByDb();
  }

  getConditionByDb() async {
    getConditionList = await GetConditionList;
    setState(() {
      flg = false;
    });
  }

  // End condition with local db

  //===== Medicines with local db operations:

  Future<int> saveInitialMedicines(int indexValue) async {
    setState(() {
      _medication;
    });
    print(
        'Medicine Id: ${_medication[indexValue].id} and Name: ${_medication[indexValue].name}');
    int id = await dbHelper.insertInitialMedicines(InitMedication(
      null,
      _medication[indexValue].name,
    ));
    return id;
  }

  loadMedicinesToDB() {
    for (int i = 0; i < _medication.length; i++) {
      saveInitialMedicines(i);
    }
  }

  GetMedicines() {
    setState(() {
      GetMedicinesList = dbHelper.getInitialMedicines();
    });
    getMedicinesByDb();
  }

  getMedicinesByDb() async {
    getMedicinesList = await GetMedicinesList;
    setState(() {
      flg = false;
    });
    // print(
    //     " Id: ${getMedicinesList[61693].id.toString()} , Medicine name: ${getMedicinesList[61693].name} ");
    // seeMedicine(getMedicinesList);
  }

  // seeMedicine(List<InitMedication> med) {
  //   for (int i = 0; i < 100000; i++) {
  //     print(med[i].id);
  //   }
  // }

  //==== End Medicines with local db

  //===== Unwell initial operation:
  Future<int> saveUnwellList(UnwellList unwell) async {
    int id = await dbHelper.insertDefaultUnwellList(UnwellList(
        // null,
        // '', // fsEmail,
        // _condition[indexValue].name,
        // _condition[indexValue].images,
        unwell.id,
        unwell.stConditonName,
        unwell.stImageName));
    return id;
  }

  loadUnwellListToDB() {
    List<UnwellList> insertUnwellList = new List<UnwellList>();
    insertUnwellList = [
      UnwellList(null, "Other", "assets/images/Disease test 5.png"),
      UnwellList(null, "Zika Virus", "assets/images/generic.png"),
      UnwellList(null, "West Nile Virus", "assets/images/generic.png"),
      UnwellList(null, "Yellow Fever", "assets/images/generic.png"),
      UnwellList(null, "Skin Disorder", "assets/images/Skin Disorder.png"),
      UnwellList(null, "Stomach Aches", "assets/images/Stomach Aches.png"),
      UnwellList(null, "Headaches", "assets/images/Headaches.png"),
      UnwellList(null, "Diarrhea", "assets/images/Diarrhea.png"),
      UnwellList(null, "Ear Discomfort", "assets/images/Ear Discomfort.png"),
      UnwellList(null, "Eye Discomfort", "assets/images/Eye Discomfort.png"),
      UnwellList(null, "Colds and Flu", "assets/images/Colds and Flu.png"),
      UnwellList(null, "Allergies", "assets/images/Allergies.png"),
    ];
    for (int i = 0; i < insertUnwellList.length; i++) {
      saveUnwellList(insertUnwellList[i]);
    }
  }

  BindUnwellList() {
    setState(() {
      GetUnwellList = dbHelper.getDefaultUnwellList();
    });
    getUnwellListByDb();
  }

  getUnwellListByDb() async {
    getUnwellList = await GetUnwellList;
    setState(() {
      flg = false;
    });
  }

  //==== Unwell operations ends

  //==== Weekly Monthly Default Health Status

  Future<int> saveWeeklyStatusData(
      String fsEmail, var fsDate, var fsMonth, var fsWeekDay) async {
    int id = await dbHelper.insertWeeklyHealthStatus(WeeklyAndMonthlyStatus(
        null, fsEmail, fsDate, fsMonth, 0, fsWeekDay, 0));
    return id;
  }

  loadWeeklyMonthlyData() {
    for (int i = 29; i >= 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      saveWeeklyStatusData('', date.day.toString(), date.month.toString(),
          date.weekday.toString());
    }
  }

  BindWeeklyMonthlyData() {
    setState(() {
      WeeklyAndMonthlyDefaultStatus = dbHelper.getMonthlyHealthStatus();
    });
    getWeeklyMonthlyDataFromDb();
  }

  getWeeklyMonthlyDataFromDb() async {
    weeklyAndMonthlyDefaultStatus = await WeeklyAndMonthlyDefaultStatus;
    setState(() {
      flg = false;
    });
  }

  //===== End Weekly Monthly Operations
  //===Condition and Medition Operation from json:

  Future<String> _loadConditionAsset() async {
    return await rootBundle.loadString('assets/condition.json');
  }

  BindCondition() async {
    String jsonAddress = await _loadConditionAsset();
    var jsonResponse = json.decode(jsonAddress);
    conditionList = ConditionList.fromJson(jsonResponse);
    setState(() {
      _condition = conditionList.conditions;
    });
  }

  Future<String> _loadMedicationAsset() async {
    return await rootBundle.loadString('assets/medication.json');
  }

  BindMedication() async {
    String jsonAddress = await _loadMedicationAsset();
    var jsonResponse = json.decode(jsonAddress);
    medicationList = MedicationList.fromJson(jsonResponse);
    setState(() {
      _medication = medicationList.medication;
      // _isLoading = false;
    });
    print('Id: ${_medication[100].id} and Name: ${_medication[100].name}');
  }

  //======= End

  @override
  Widget build(BuildContext context) {
    // flg = false;
    setState(() {
      conBtn;
      medBtn;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: flg || getConditionList == null || getMedicinesList == null
          ? Center(child: Text('Loading...'))
          : Center(
              child: IgnorePointer(
                ignoring: conBtn || medBtn ? true : false,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          conBtn
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.blue),
                                )
                              : squareBtn(context, "Add Conditions", () {
                                  conBtn = true;
                                  pickFiless(1);
                                }, 300, 100),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'No. of records: ${getConditionList.length.toString()}'),
                        ]),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            medBtn
                                ? Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.blue),
                                  )
                                : squareBtn(context, "Add Medicines", () {
                                    medBtn = true;
                                    pickFiless(2);
                                  }, 300, 100),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'No of records: ${getMedicinesList.length.toString()}')
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          squareBtn(context, "Add Unwell List", () {
                            if (getUnwellList == null ||
                                getUnwellList.length == 0) {
                              loadUnwellListToDB();
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoadingScreen(
                                      title: 'Hyd data loader',
                                    )));
                          }, 300, 100),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'No. of records: ${getUnwellList.length.toString()}'),
                        ]),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            squareBtn(context, "Add week-data", () {
                              if (weeklyAndMonthlyDefaultStatus == null ||
                                  weeklyAndMonthlyDefaultStatus.length == 0) {
                                loadWeeklyMonthlyData();
                              }
                              //loadWeeklyMonthlyData();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                        title: 'Hyd data loader',
                                      )));
                            }, 300, 100),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'No of records: ${weeklyAndMonthlyDefaultStatus.length.toString()}')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Pressed');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget squareBtn(BuildContext context, String btnText, Function onTapFunc,
      double h, double w) {
    return Material(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.white,
        onTap: onTapFunc,
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              )),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 12, top: 4, left: 5, right: 5),
            child: Text(
              btnText,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'INTER'),
            ),
          ),
        ]),
      ),
    );
  }
}
