/*
Example of Json representation of an exercise:

"exID": "39",
    "mg": "1",
    "mg1": "1",
    "mg2": "2",
    "eqType": "Cable",
    "name": "Cable Wide Grip Upright Row",
    "diff": "3",
    "utility": "Basic",
    "mechanics": "Compound",
    "force": "Pull",
    "link": "https://www.exrx.net/WeightExercises/DeltoidLateral/CBWideGripUprightRow",
 */
// only for usage with the new dataset

import 'dart:collection';
import 'package:advanced_workout_planner/Globals.dart';

class Exercise {
  String _exID;

  // Supporting up to 3 target muscle groups for one exercise.
  MgId _mg;
  MgId _mg1;
  MgId _mg2;

  String _eqType;
  String _name;
  String _diff;
  String _utility;
  String _mechanics;
  String _force;
  String _link;

  /// Contains all the column names for exercise representation.
  static const List<String> exerciseColumnNames = [
    'exID',
    'mg',
    'mg1',
    'mg2',
    'eqType',
    'name',
    'diff',
    'utility',
    'mechanics',
    'force',
    'link',
  ];

  Exercise(this._exID, this._mg, this._mg1, this._mg2, this._eqType, this._name, this._diff, this._utility,
      this._mechanics, this._force, this._link);

  // Exercise values getters

  String get link => _link;

  String get force => _force;

  String get mechanics => _mechanics;

  String get utility => _utility;

  String get diff => _diff;

  String get name => _name;

  String get eqType => _eqType;

  MgId get mg2 => _mg2;

  MgId get mg1 => _mg1;

  MgId get mg => _mg;

  String get exID => _exID;

  /// Returns value of a given column for the exercise. Not case sensitive.
  ///
  /// Returns empty string if column name is incorrect.
  String getColumn(String sColumn) {
    String sRet = '';
    switch (sColumn.toLowerCase()) {
      case 'exid':
        sRet = _exID;
        break;
      case 'mg':
        sRet = _mg.toString();
        break;
      case 'mg1':
        sRet = _mg1.toString();
        break;
      case 'mg2':
        sRet = _mg2.toString();
        break;
      case 'eqtype':
        sRet = _eqType;
        break;
      case 'name':
        sRet = _name;
        break;
      case 'diff':
        sRet = _diff;
        break;
      case 'utility':
        sRet = _utility;
        break;
      case 'mechanics':
        sRet = _mechanics;
        break;
      case 'force':
        sRet = _force;
        break;
      case 'link':
        sRet = _link;
        break;
    }
    return sRet;
  }

  /// Returns map of exercise properties in words.
  ///
  /// Exercise properties: Difficulty, Utility, Mechanics, Force
  LinkedHashMap<String, String> getExerciseProperties() {
    // Linked HashMap to preserve the order of keys.
    LinkedHashMap<String, String> prop = new LinkedHashMap<String, String>();

    prop.addAll({"diff": diffToString(), "utility": _utility, "mechanics": _mechanics, "force": _force});

    return prop;
  }

  /// Returns difficulty of an exercise in words (Easy, Medium, Hard)
  String diffToString() {
    String str = "";

    if (_diff == "1") {
      str = "Easy";
    } else if (_diff == "2") {
      str = "Medium";
    } else {
      str = "Hard";
    }

    return str;
  }

  /// Returns explanation of given property. Not case sensitive.
  ///
  /// Explained properties: utility, mechanics, force, basic, auxiliary, compound, isolated, push, pull
  /// TODO - Different implementation of getting description of properties! -- database
  String getPropertyExplanation(String property) {
    switch (property.toLowerCase().replaceAll(":", "")) {
      case 'basic':
        return utilityBasicExplanationENG;
      case 'auxiliary':
        return utilityAuxiliaryExplanationENG;
      case 'compound':
        return mechanicsCompoundExplanationENG;
      case 'isolated':
        return mechanicsIsolatedExplanationENG;
      case 'push':
        return forcePushExplanationENG;
      case 'pull':
        return forcePullExplanationENG;
      case 'utility':
        return 'Basic:\n' + utilityBasicExplanationENG + '\n\nAuxiliary:\n' + utilityAuxiliaryExplanationENG;
      case 'mechanics':
        return 'Compound:\n' + mechanicsCompoundExplanationENG + '\n\nIsolated:\n' + mechanicsIsolatedExplanationENG;
      case 'force':
        return 'Push:\n' + forcePushExplanationENG + '\n\nPull:\n' + forcePullExplanationENG;
    }
    return "";
  }
}

// MgId represents muscle group id and consists of 3 levels of subgroups:
// sg0 is the main muscle group - for example: Shoulders
// sg1 is the first subgroup level - for example: Deltoid
// sg2 is the second subgroup level - for example: Front Deltoid
class MgId {
  String _fullMg;

  // Muscle subgroups
  String _sg0;
  String _sg1;
  String _sg2;

  List arr = new List<String>();

  // Parse full mg id to subgroups
  MgId(this._fullMg) {
    arr = _fullMg.split('.');

    if (arr.length == 1) {
      _sg0 = arr[0];
      _sg1 = "";
      _sg2 = "";
    } else if (arr.length == 2) {
      _sg0 = arr[0];
      _sg1 = arr[1];
      _sg2 = "";
    } else if (arr.length == 3) {
      _sg0 = arr[0];
      _sg1 = arr[1];
      _sg2 = arr[2];
    }
  }

  @override
  String toString() {
    if (this._sg1 == "") {
      return this._sg0;
    } else if (this._sg2 == "") {
      return this._sg0 + "." + this._sg1;
    } else {
      return this._sg0 + "." + this._sg1 + "." + this._sg2;
    }
  }

  String get sg0 => _sg0;

  String get sg2 => _sg2;

  String get sg1 => _sg1;
}
