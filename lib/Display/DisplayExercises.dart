import 'package:advanced_workout_planner/Display/DisplayComponents/FilterPage.dart';
import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Display/DisplayComponents/AppBarSearch.dart';
import 'package:advanced_workout_planner/Display/DisplayComponents/ExercisesListView.dart';
import '../Data/AppSettings.dart';
import 'package:advanced_workout_planner/Display/DisplayComponents/AppDrawer.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class DisplayExercises extends StatefulWidget {
  MuscleGroup muscleGroup;
  Color color;

  DisplayExercises(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
  }

  @override
  _DisplayExercisesState createState() => _DisplayExercisesState(muscleGroup);
}

class _DisplayExercisesState extends State<DisplayExercises> {
  MuscleGroup muscleGroup;

  Map<String, List<String>> mapSettingsBck = new Map<String, List<String>>();
  Color color;
  Map<String, dynamic> jsonData;
  int debug = 0;

  final AppSettings settings = new AppSettings();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _DisplayExercisesState(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
    this.color = Colors.white;
    globals.currentScreen = "DisplayExercises";
  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
          child: AppBarSearch(
            // First letter to uppercase
            title: "${muscleGroup.sMuscleGroupName[0].toUpperCase()}${muscleGroup.sMuscleGroupName.substring(1)}",
            refresh: _refresh,
            openEndDrawer: openEndDrawer,
            muscleGroup: muscleGroup,
          ),
          preferredSize: preferredSize),
      body: new ExercisesListView(
        title: muscleGroup.sMuscleGroupName,
        refresh: _refresh,
        muscleGroup: muscleGroup,
      ),
      drawer: new AppDrawer(muscleGroup),
      endDrawer: FilterPage(muscleGroup, _refresh),
    );
  }

  void _refresh() {
    setState(() {});
  }

  void openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }
}
