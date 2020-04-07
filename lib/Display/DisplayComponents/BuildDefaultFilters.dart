import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Logic/Exercise.dart';

class BuildDefaultFilters extends StatefulWidget {
  MuscleGroup muscleGroup;
  Function refresh;

  BuildDefaultFilters(MuscleGroup muscleGroup, Function refresh) {
    this.muscleGroup = muscleGroup;
    this.refresh = refresh;
  }

  @override
  _BuildDefaultFiltersState createState() => _BuildDefaultFiltersState(muscleGroup);
}

class _BuildDefaultFiltersState extends State<BuildDefaultFilters> {
  MuscleGroup muscleGroup;

  _BuildDefaultFiltersState(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    return Row(children: <Widget>[
      Container(
        width: c_width * 0.5,
        child: ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            // ### Difficulty
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    'Difficulty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
                height: 35,
//                color: Colors.white,
                child: CheckboxListTile(
                  // Value of a checkBox equals stored value in map [MuscleGroup.mapFiltersCheckBoxValues].
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_easy"],
                  onChanged: (bool value) {
                    setState(() {
                      // TODO - Should be able to select 2 or 3 checkboxes - only for difficulty!
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = false;

                      // Setting filters in map [MuscleGroup._mapFilters].
                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      // Calling method which filters [MuscleGroup.listExercisesToDisplay].
                      muscleGroup.filterExercises();
                      // Calling set state to refresh the widget tree.
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Easy")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_medium"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = false;

                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Medium")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_hard"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = false;

                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Hard")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),

            Padding(
              padding: EdgeInsets.all(15),
            ),

            // ### Mechanics
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    'Mechanics',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["mechanics_comp"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["mechanics_comp"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["mechanics_iso"] = false;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          mechanics: getSelectedMechanics());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Compound")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["mechanics_iso"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["mechanics_comp"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["mechanics_iso"] = value;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          mechanics: getSelectedMechanics());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Isolated")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),

            Padding(
              padding: EdgeInsets.all(15),
            ),

            // ### Force
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    'Force',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["force_push"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["force_push"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["force_pull"] = false;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          force: getSelectedForce());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Push")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["force_pull"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["force_push"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["force_pull"] = value;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          force: getSelectedForce());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Pull")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),

            Padding(
              padding: EdgeInsets.all(15),
            ),

            // ### Utility
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    'Utility',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["util_basic"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["util_basic"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["util_auxil"] = false;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          utility: getSelectedUtility());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Basic")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["util_auxil"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["util_basic"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["util_auxil"] = value;

                      muscleGroup.setFilters(
                          saveValues: true,
                          mg: new MgId(muscleGroup.getMainMuscleGroupId()),
                          utility: getSelectedUtility());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title:
                      new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Auxiliary")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),

            Padding(
              padding: EdgeInsets.all(15),
            ),
          ],
        ),
      ),

      // ######
      // ### Equipment type TODO
      /*Container(
        width: c_width * 0.4,
        child: ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            // ### Difficulty
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    'Equipe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
                height: 35,
                color: Colors.white,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_easy"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = false;

                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Easy")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_medium"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = false;

                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Medium")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
            Container(
                height: 35,
                child: CheckboxListTile(
                  value: muscleGroup.mapFiltersCheckBoxValues["diff_hard"],
                  onChanged: (bool value) {
                    setState(() {
                      muscleGroup.mapFiltersCheckBoxValues["diff_hard"] = value;
                      muscleGroup.mapFiltersCheckBoxValues["diff_medium"] = false;
                      muscleGroup.mapFiltersCheckBoxValues["diff_easy"] = false;

                      muscleGroup.setFilters(
                          saveValues: true, mg: new MgId(muscleGroup.getMainMuscleGroupId()), diff: getSelectedDiff());
                      muscleGroup.filterExercises();
                      this.widget.refresh();
                    });
                  },
                  title: new Text.rich(TextSpan(style: TextStyle(fontSize: 20, color: Colors.black), text: "Hard")),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                )),
          ],
        ),
      ),*/
    ]);
  }

  // Selected checkbox getters

  String getSelectedDiff() {
    if (muscleGroup.mapFiltersCheckBoxValues["diff_easy"])
      return "1";
    else if (muscleGroup.mapFiltersCheckBoxValues["diff_medium"])
      return "2";
    else if (muscleGroup.mapFiltersCheckBoxValues["diff_hard"])
      return "3";
    else
      return "";
  }

  String getSelectedMechanics() {
    if (muscleGroup.mapFiltersCheckBoxValues["mechanics_comp"])
      return "Compound";
    else if (muscleGroup.mapFiltersCheckBoxValues["mechanics_iso"])
      return "Isolated";
    else
      return "";
  }

  String getSelectedForce() {
    if (muscleGroup.mapFiltersCheckBoxValues["force_push"])
      return "Push";
    else if (muscleGroup.mapFiltersCheckBoxValues["force_pull"])
      return "Pull";
    else
      return "";
  }

  String getSelectedUtility() {
    if (muscleGroup.mapFiltersCheckBoxValues["util_basic"])
      return "Basic";
    else if (muscleGroup.mapFiltersCheckBoxValues["util_auxil"])
      return "Auxiliary";
    else
      return "";
  }
}
