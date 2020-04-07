import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'Display/DisplayExercises.dart';

import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);
final debug = 0;

/// Class is taken and changed from a flutter app example
class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;

  const Category({
    Key key,
    @required this.name,
    @required this.color,
    @required this.iconLocation,
  })  : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: () async {
            /// MuscleGroup object serves as a logic and communication center.
            ///
            /// When a category is pressed a muscle group object is created and passed to the child class [DisplayExercises].
            /// From there the object is passed around and used as a center for communication between
            /// a program and assets/local file storage.
            /// Through this object the program loads data from assets, manipulates with the storage used for storing
            /// app settings (e.g. favourited exercises: map [MuscleGroup.mapSettings], local file storage [MuscleGroup.settings])
            /// and filters which exercises to display on the screen [MuscleGroup.listExercisesToDisplay].
            MuscleGroup muscleGroup = new MuscleGroup(name.toLowerCase());

            await muscleGroup.init();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisplayExercises(muscleGroup)),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 14),
                  child: Icon(
                    iconLocation,
                    size: 45.0,
                    color: Colors.white54,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 21.0,
                      fontWeight: FontWeight.w500,
                    ), //
                    textScaleFactor: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
