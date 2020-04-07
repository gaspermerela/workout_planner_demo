import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class AppSettings {
  // TODO - file name different implementation

  /// Returns local path of documents directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the local file that can be used to write/read data.
  Future<File> get _localFile async {
    final path = await _localPath;

    return new File('$path/${globals.settingsFilename}');
  }

  /// Writes given string to a settings file.
  Future<File> writeUserSetting(String setting) async {
    // getSettings can serve as a file checking tool.
    getSettings();
    final file = await _localFile;
    return file.writeAsString('$setting');
  }

  /// Returns the settings file contents as a string.
  Future<String> _getUserSettings() async {
    String contents;
    try {
      final file = await _localFile;
      // read the file
      contents = await file.readAsString();
    } catch (e) {
      print(e);
    }

    return contents;
  }

  /// Deletes the settings file.
  Future<FileSystemEntity> removeUserSettingsFile() async {
    final file = await _localFile;
    return file.delete();
  }

  /// Checks if settings file exist.
  Future<bool> _settingsFileExists() async {
    File settingsFile = await _localFile;

    if (await settingsFile.exists()) {
      return true;
    }
    return false;
  }

  /// Checks if the given string contains all required map keys (to avoid null exceptions).
  bool _checkSettingsString(String str) {
    if (str != null && str.contains('favouritesID')) {
      return true;
    }
    return false;
  }

  /// Writes empty settings map to local file.
  void clearSettings() async {
    writeUserSetting(json.encode({'favouritesID': []}));
  }

  /// Returns parsed settings data, checks if file exist and if contains all required map keys.
  ///
  /// If the check is invalid a new file with empty map containing required map keys is created.
  Future<Map<String, List<String>>> getSettings() async {
    Map<String, dynamic> jsonData;
    await _settingsFileExists().then((data) async {
      if (data) {
        await _getUserSettings().then((data) async {
          if (_checkSettingsString(data)) {
            jsonData = json.decode(data);
          } else {
            clearSettings();
          }
        });
      } else {
        clearSettings();
      }
    });

    if (jsonData == null) jsonData = {'favouritesID': []};

    Map<String, List<String>> jsonDataConverted = Map.from(jsonData.map((key, value) {
      List<dynamic> values = List.from(value);
      return MapEntry(
          key.toString(),
          values.map((theValue) {
            return theValue.toString();
          }).toList());
    }));

    return jsonDataConverted;
  }
}
