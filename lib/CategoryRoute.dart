import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Category.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

final _backgroundColor = Colors.lightBlue[200];

/// Class is taken and changed from a flutter app example
class CategoryRoute extends StatelessWidget {
  const CategoryRoute();

  /// List of muscle group names. List is expanding alongside with JSON dataset
  static const _categoryNames = <String>[
    'Shoulders',
    'Arms',
    'Forearms',
    'Back',
    'Chest',
    'Core',
    'Legs',
  ];

  /// Color that is shown on button (Inkwell) when category is pressed
  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  Widget _buildCategoryWidgets(List<Widget> categories) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => categories[index],
      itemCount: categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = <Category>[];
    for (var i = 0; i < _categoryNames.length; i++) {
      categories.add(Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.fitness_center,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        flexibleSpace: Container(
          decoration: globals.appBarBoxDecoration,
        ),
        title: Text(
          'Advanced Workout Planner',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: _backgroundColor,
      ),
      body: Container(
        decoration: globals.boxDecoration,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildCategoryWidgets(categories),
      ),
    );
  }
}
