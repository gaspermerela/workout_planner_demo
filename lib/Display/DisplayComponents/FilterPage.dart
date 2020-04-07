import 'package:advanced_workout_planner/Display/DisplayComponents/BuildDefaultFilters.dart';
import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'dart:ui';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class FilterPage extends StatefulWidget {
  MuscleGroup muscleGroup;
  Function refresh;

  FilterPage(MuscleGroup muscleGroup, Function refresh) {
    this.muscleGroup = muscleGroup;
    this.refresh = refresh;
  }

  @override
  _FilterPageState createState() => new _FilterPageState(muscleGroup);
}

class _FilterPageState extends State<FilterPage> {
  // TODO - getting file path - different implementation - Globals
  MuscleGroup muscleGroup;
  int _count = 0;

  _FilterPageState(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
    this._count = muscleGroup.listExercisesToDisplay.length;
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.75;
    return new Opacity(
        opacity: 0.75,
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // * 0.6, //20.0,
          child: Drawer(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: globals.drawerBoxDecoration,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 10, bottom: 15, top: 75),
                            width: c_width * 6,
                            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                              // Title
                              Text(
                                "Default Filters",
                                style: TextStyle(color: Colors.white, fontSize: 34),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.sort,
                                size: 35,
                                color: Colors.white,
                              ),
                              SizedBox(width: 30),
                              // Real time counter of exercises that meet the filter requirements.
                              Text(
                                "$_count",
                                style: TextStyle(color: Colors.white, fontSize: 34),
                              ),
                            ])),
//                      ],
                        Padding(
                          padding: EdgeInsets.all(15),
                        ),

                        BuildDefaultFilters(muscleGroup, _refresh),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  // Refreshes parent screen and _count to new listExercisesToDisplay.length.
  void _refresh() {
    setState(() {
      _count = muscleGroup.listExercisesToDisplay.length;
    });
    widget.refresh();
  }
}
