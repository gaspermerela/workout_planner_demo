import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

/// Returns a string containing the contents of a file on a given file path.
Future<String> _loadAsset(String file) async {
  return await rootBundle.loadString(file);
}

/// Returns parsed jsonString in a List<dynamic> form.
List _parseJsonForExercises(String jsonStr) {
  List decoded = jsonDecode(jsonStr);
  return decoded;
}

/// Returns List<Map<String, String>> of data from asset file that stores exercise data [Globals.fileAssetExercises].
Future<List<Map<String, String>>> loadExercises(String file) async {
  String jsonStr = await _loadAsset(file);
  List data = _parseJsonForExercises(jsonStr);

  List<Map<String, String>> newData = new List<Map<String, String>>();

  // Parsing data from List<dynamic> to List<Map<String, String>>
  for (int i = 0; i < data.length; i++) {
    newData.add({
      "exID": data[i]["exID"],
      "mg": data[i]["mg"],
      "mg1": data[i]["mg1"],
      "mg2": data[i]["mg2"],
      "eqType": data[i]["eqType"],
      "name": data[i]["name"],
      "diff": data[i]["diff"],
      "utility": data[i]["utility"],
      "mechanics": data[i]["mechanics"],
      "force": data[i]["force"],
      "link": data[i]["link"],
    });
  }

  return newData;
}
