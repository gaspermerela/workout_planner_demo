import 'package:advanced_workout_planner/Display/DisplayComponents/BuildDefaultFilters.dart';
import 'package:advanced_workout_planner/Logic/Exercise.dart';
import 'package:advanced_workout_planner/Data/DataParser.dart';
import 'package:advanced_workout_planner/Data/AppSettings.dart';
import 'dart:convert';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class MuscleGroup {
  String sMuscleGroupName;

  /// Communication with map [mapSettings] and fileSettings file stored in local storage.
  final AppSettings settings = new AppSettings();

  List<Exercise> listExercisesAll = new List<Exercise>();
  List<Exercise> listExercisesMuscleGroup = new List<Exercise>();
  List<Exercise> listExercisesToDisplay = new List<Exercise>();

  static const List<String> listExerciseColumnNames = [
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
    'linkGif'
  ];

  /// Local data collection of favourited exercises IDs
  Map<String, List<String>> mapSettings = new Map<String, List<String>>();

  /// mg ID to muscle group name with Capital first letter
  static const Map<String, String> mapMuscleGroupIDToString = {
    "1": "Shoulders",
    "2": "Arms",
    "3": "Forearms",
    "4": "Back",
    "5": "Chest",
    "6": "Core",
    "7": "Legs",
  };

  /// Lowercase muscle group name to mg ID
  static const Map<String, String> mapMainMuscleGroupToId = {
    "shoulders": "1",
    "arms": "2",
    "forearms": "3",
    "back": "4",
    "chest": "5",
    "core": "6",
    "legs": "7",
  };

  /// Map and Muscle group for filtering displayed exercises.
  ///
  /// Steps to take to filter displayed exercises:
  /// 1. Setting the filters with [MuscleGroup.setFilters] method
  /// 2. Calling [MuscleGroup.filterExercises]
  /// 3. Refresh the screen with set state method (possibly a parent screen)
  Map<String, String> _mapFilters = {"eqType": "", "diff": "", "utility": "", "mechanics": "", "force": ""};
  MgId _filterMgId;

  /// Map for storing which filters are enabled.
  Map<String, bool> mapFiltersCheckBoxValues = {
    "diff_easy": false,
    "diff_medium": false,
    "diff_hard": false,
    "mechanics_comp": false,
    "mechanics_iso": false,
    "force_push": false,
    "force_pull": false,
    "util_basic": false,
    "util_auxil": false,
  };

  MuscleGroup(String sMuscleGroupName) {
    this.sMuscleGroupName = sMuscleGroupName.toLowerCase();
  }

  /// After creating [MuscleGroup] object it is necessary to call [MuscleGroup.init] method.
  ///
  /// Loads [listExercisesAll] with all exercises from asset JSON file
  /// Loads [listExercisesMuscleGroup] with filtered exercises for [sMuscleGroupName] from [listExercisesAll]
  /// Loads [listExercisesToDisplay] with [listExercisesMuscleGroup]
  /// Loads [mapSettings] from assets
  init() async {
    listExercisesAll.clear();
    listExercisesAll.addAll(await getExercisesFromAssets());

    listExercisesMuscleGroup.clear();
    // The initial [listExercisesToDisplay] are exercises for a specific muscle group.
    listExercisesMuscleGroup.addAll(getExercisesOfMuscleGroup(sMuscleGroupName));

    /// Setting filters to specific muscle group so that [MuscleGroup.changeDisplayedExercises] can correctly display exercises.
    setFilters(mg: new MgId("${mapMainMuscleGroupToId[sMuscleGroupName]}"));

    listExercisesToDisplay.clear();
    listExercisesToDisplay.addAll(listExercisesMuscleGroup);

    await _refreshLocalSettingsFromAssets();
  }

  /// Returns main id of muscle group (sg0)
  String getMainMuscleGroupId() {
    if (sMuscleGroupName != "") {
      return mapMainMuscleGroupToId[sMuscleGroupName.toLowerCase()];
    } else {
      return "";
    }
  }

  /// Returns data of all exercises from assets.
  ///
  /// This data (<List<Map<String, String>>> ) has to be converted to other type (List<Exercise>)
  Future<List<Map<String, String>>> _getExercisesDataFromAssets() async {
    List<Map<String, String>> data = await loadExercises(globals.sExercisesFile);
    return data;
  }

  /// Returns all converted exercise data in the form List<Exercise> from assets
  Future<List<Exercise>> getExercisesFromAssets() async {
    List<Map<String, String>> dataAllExercises = await _getExercisesDataFromAssets();
    List<Exercise> exerciseList = new List<Exercise>();

    for (int i = 0; i < dataAllExercises.length; i++) {
      exerciseList.add(new Exercise(
          dataAllExercises[i]['exID'],
          new MgId(dataAllExercises[i]['mg']),
          new MgId(dataAllExercises[i]['mg1']),
          new MgId(dataAllExercises[i]['mg2']),
          dataAllExercises[i]['eqType'],
          dataAllExercises[i]['name'],
          dataAllExercises[i]['diff'],
          dataAllExercises[i]['utility'],
          dataAllExercises[i]['mechanics'],
          dataAllExercises[i]['force'],
          dataAllExercises[i]['link']));
    }
    return exerciseList;
  }

  /// Returns list of exercises for given muscle group NAME. Not case sensitive.
  List<Exercise> getExercisesOfMuscleGroup(String sMuscleGroup) {
    List<Exercise> filtered = new List<Exercise>();

    for (int i = 0; i < listExercisesAll.length; i++) {
      if (mapMuscleGroupIDToString[listExercisesAll[i].mg.sg0].toLowerCase() == sMuscleGroup.toLowerCase()) {
        filtered.add(listExercisesAll[i]);
      }
    }
    return filtered;
  }

  /// Returns list of Exercises, filtered based parameters set in map [_mapFilters].
  ///
  /// If filter value is set to "" (empty string), it meets the requirements for any given value in this column.
  List<Exercise> getFilteredExercises() {
    List<Exercise> filtered = new List<Exercise>();

    for (int i = 0; i < listExercisesAll.length; i++) {
      Exercise ex = listExercisesAll[i];
      bool pass = true;

      for (int i = 0; i < _mapFilters.length; i++) {
        if (_filterMgId != null &&
            !(compareMgId(_filterMgId, ex.mg) || compareMgId(_filterMgId, ex.mg1) || compareMgId(_filterMgId, ex.mg2)))
          pass = false;
        if (_mapFilters["eqType"] != "" && ex.eqType != _mapFilters["eqType"]) pass = false;
        if (_mapFilters["diff"] != "" && ex.diff != _mapFilters["diff"]) pass = false;
        if (_mapFilters["utility"] != "" && ex.utility != _mapFilters["utility"]) pass = false;
        if (_mapFilters["mechanics"] != "" && ex.mechanics != _mapFilters["mechanics"]) pass = false;
        if (_mapFilters["force"] != "" && ex.force != _mapFilters["force"]) pass = false;
      }

      if (pass) {
        filtered.add(ex);
      }
    }
    return filtered;
  }

  /// Returns List of favourited Exercises filtered by muscle group NAME, IF specified.
  /// Otherwise gets all favourited exercises.
  List<Exercise> getFavouriteExercises({String sMuscleGroup}) {
    List<Exercise> favEx = new List<Exercise>();

    for (int i = 0; i < listExercisesAll.length; i++) {
      if (mapSettings['favouritesID'].contains(listExercisesAll[i].exID)) {
        if (sMuscleGroup == null || mapMuscleGroupIDToString[listExercisesAll[i].mg.sg0.toString()] == sMuscleGroup) {
          favEx.add(listExercisesAll[i]);
        }
      }
    }
    return favEx;
  }

  /// Returns List<String> of Exercise IDs of all favourited Exercises.
  List<String> getAllFavouritesIDs() {
    return mapSettings['favouritesID'];
  }

  /// Returns List<String> of Exercise IDs of all favourited Exercises.
  List<String> getAllFavouritesIDsFromExerciseList(List<Exercise> listEx) {
    List<String> list = new List<String>();

    listEx.forEach((element) {
      if (mapSettings['favouritesID'].contains(element.exID)) {
        list.add(element.exID);
      }
    });

    return list;
  }

  /// Returns List<String> of Exercise IDs of all Exercises.
  List<String> getAllExercisesIDs() {
    List<String> filteredExIDs = new List<String>();

    List<Exercise> exList = new List<Exercise>();

    for (int i = 0; i < exList.length; i++) {
      filteredExIDs.add(exList[i].exID);
    }

    return filteredExIDs;
  }

  /// Returns List<String> of values for specified column name from given list of Exercises.
  ///
  /// If column name incorrect returns empty List<String>.
  List<String> getColumnFromExerciseList(List<Exercise> listExercises, String sColumn) {
    List<String> listColumn = new List<String>();
    if (!listExerciseColumnNames.contains(sColumn)) {
      return listColumn;
    }
    listExercises.forEach((exercise) => listColumn.add(exercise.getColumn(sColumn)));
    return listColumn;
  }

  /// Returns true if exercise ID is in a list of favourited exercises IDs - [mapSettings['favouritesID']].
  bool isExerciseFavourited(Exercise exercise) {
    if (mapSettings['favouritesID'].contains(exercise.exID))
      return false;
    else
      return true;
  }

  /// Method for setting filters values in map [_mapFilters] corresponding to values of Exercise columns.
  ///
  /// If bool saveValues is set to true, not given parameters stay the same as before.
  /// If bool saveValues is set to false or is not given, not given parameters are cleared.
  void setFilters(
      {bool saveValues, MgId mg, String eqType, String diff, String utility, String mechanics, String force}) {
    Map<String, String> filters;

    if (saveValues == null || saveValues == false) {
      filters = {
        "eqType": eqType == null ? "" : eqType,
        "diff": diff == null ? "" : diff,
        "utility": utility == null ? "" : utility,
        "mechanics": mechanics == null ? "" : mechanics,
        "force": force == null ? "" : force
      };

      _filterMgId = mg;
    } else {
      filters = {
        "eqType": eqType == null ? _mapFilters["eqType"] : eqType,
        "diff": diff == null ? _mapFilters["diff"] : diff,
        "utility": utility == null ? _mapFilters["utility"] : utility,
        "mechanics": mechanics == null ? _mapFilters["mechanics"] : mechanics,
        "force": force == null ? _mapFilters["force"] : force
      };

      _filterMgId = (mg == null) ? _filterMgId : mg;
    }

    _mapFilters.clear();
    _mapFilters.addAll(filters);
  }

  /// Sets all filter values in [_mapFilters] to "".
  ///
  /// The same effect can be achieved by calling [setFilters] method without any parameters.
  void clearFilters() {
    setFilters();
  }

  /// Sets [listExercisesToDisplay] with Exercises that meet the requirements of set [_mapFilters] values.
  ///
  /// The Exercise is added to [listExercisesToDisplay] if all Exercise columns
  /// equal the value in map [_mapFilters] under the corresponding column name.
  /// If filter value in map [_mapFilters] is set to "" (empty string) filtering for this column is disabled.
  void filterExercises() {
    listExercisesToDisplay.clear();
    listExercisesToDisplay.addAll(getFilteredExercises());
  }

  /// Sets [mapSettings] to equal fileSettings contents.
  void _refreshLocalSettingsFromAssets() async {
    _clearLocalSettings();
    mapSettings.addAll(await settings.getSettings());
  }

  /// Writes mapSettings contents to fileSettings file.
  void writeSettingsToAssets() async {
    settings.writeUserSetting(json.encode(mapSettings));
  }

  /// Sets all map values in [mapSettings] to empty list.
  void _clearLocalSettings() {
    mapSettings.clear();
    mapSettings.addAll({"favouritesID": []});
  }

  /// Sets all map values in [mapSettings] and fileSettings to empty list.
  void clearAllSettings() {
    _clearLocalSettings();
    settings.clearSettings();
  }

  /// Adds Exercise ID to map [mapSettings] and map in fileSettings under the key "favouritesID".
  Future addFavouritedID(String id) async {
    mapSettings['favouritesID'].add(id);
    await writeSettingsToAssets();
  }

  /// Removes Exercise ID from map [mapSettings] and map in fileSettings under the key "favouritesID".
  Future removeFavouritedID(String id) async {
    mapSettings['favouritesID'].remove(id);
    await writeSettingsToAssets();
  }

  /// Removes from favourites all exercises that are stored in [listExercisesToDisplay].
  Future removeFavouritedIDsFromDisplayedEx() async {
    mapSettings['favouritesID'].remove("5");
    listExercisesToDisplay.forEach((element) {
      if (mapSettings['favouritesID'].contains(element.exID)) mapSettings['favouritesID'].remove(element.exID);
    });
    await writeSettingsToAssets();
  }

  /// Writes all Exercise IDs from a given List of Exercises
  /// to map [mapSettings] and to map in fileSettings under the key "favouritesID"
  void fillFavourites(List<Exercise> dataEx) {
    String index = '-1';
    for (int i = 0; i < dataEx.length; i++) {
      index = dataEx[i].exID;
      if (!mapSettings['favouritesID'].contains(index)) mapSettings['favouritesID'].add(index);
    }
    writeSettingsToAssets();
  }

  /// Changes the content of listExercisesToDisplay given the "mode" of display.
  ///
  /// Example: To change the contents of displayed exercises from regular to favourited call changeDisplayedExercises("favourites")
  /// Current modes are regular exercises and Favourited exercises.
  void changeDisplayedExercises() {
    listExercisesToDisplay.clear();
    globals.currentScreen == "DisplayExercises"
        ? listExercisesToDisplay.addAll(getFilteredExercises())
        : listExercisesToDisplay.addAll(getFavouriteExercises());
  }

  /// Returns true if the second parameter (id) is a subset of the first parameter (filterId).
  ///
  /// An id2 is a subset of id1 if id1 has defined all subgroups that are also defined in id2
  /// Example: 1.1 is a subset of 1 while 1 is not a subset of 1.1
  bool compareMgId(MgId filterId, MgId id) {
    if (filterId.sg0 == "") {
      throw new Exception("Error with data of passed arguments - filter MgId has empty sg0");
    }

    if (filterId.sg0 != id.sg0) {
      return false;
    }

    if (filterId.sg1 != "" && filterId.sg1 != id.sg1) {
      return false;
    }

    if (filterId.sg2 != "" && filterId.sg2 != id.sg2) {
      return false;
    }

    if (id.sg0 == '2') {
      print("err");
    }
    return true;
  }
}