import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CategoryRoute.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Workout Planner',
      home: CategoryRoute(),
    );
  }
}
