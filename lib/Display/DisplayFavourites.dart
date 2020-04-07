import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Display/DisplayComponents/ExercisesListView.dart';
import 'package:advanced_workout_planner/Display/DisplayComponents/AppBarSearch.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class DisplayFavourites extends StatefulWidget {
  MuscleGroup muscleGroup;

  DisplayFavourites(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
  }

  @override
  _DisplayFavouritesState createState() => _DisplayFavouritesState(muscleGroup);
}

class _DisplayFavouritesState extends State<DisplayFavourites> {
  MuscleGroup muscleGroup;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  _DisplayFavouritesState(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
    globals.currentScreen = "DisplayFavourites";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // Move from DisplayFavourites to DisplayExercises
        onWillPop: () {
          globals.currentScreen = "DisplayExercises";
          muscleGroup.changeDisplayedExercises();
          // Trigger leaving and use own data
          Navigator.pop(context, false);

          // We need to return a future
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: new PreferredSize(
              child: AppBarSearch(
                title: 'Favourites',
                refresh: _refresh,
                muscleGroup: muscleGroup,
              ),
              preferredSize: preferredSize),
          body: new ExercisesListView(
            title: 'Favourites',
            refresh: _refresh,
            muscleGroup: muscleGroup,
          ),
        ));
  }

  void _refresh() {
    setState(() {});
  }
}
