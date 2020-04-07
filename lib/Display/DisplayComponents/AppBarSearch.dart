import 'package:advanced_workout_planner/Data/AppSettings.dart';
import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'package:advanced_workout_planner/Logic/Exercise.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class AppBarSearch extends StatefulWidget {
  final MuscleGroup muscleGroup;

  final Function refresh;
  final Function openEndDrawer;
  final String title;

  const AppBarSearch({this.muscleGroup, this.title, Key key, this.refresh, Key key1, this.openEndDrawer})
      : super(key: key);

  @override
  _AppBarSearchState createState() => _AppBarSearchState(muscleGroup, title);
}

class _AppBarSearchState extends State<AppBarSearch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Writing and reading data from setting file in local storage.
  final AppSettings settings = new AppSettings();

  MuscleGroup muscleGroup;

  /// This collection contains all exercises parsed from assets upon [muscleGroup] object creation.
  ///
  /// [dataEx] is used when we want to display original list of exercises loaded at the beginning.
  List<Exercise> dataEx;

  /// Storing exercises removed from display when "unfavouriting all" in Favourited Display screen.
  ///
  /// When displaying favorites there is an option to unfavourite all the exercises.
  /// These exercises are removed from the displayed screen - removed from [MuscleGroup.listExercisesToDisplay].
  /// If we want to undo that change we have to store previously displayed exercises.
  List<Exercise> dataExBck = new List<Exercise>();

  String title;

  /// Storing app settings (e.g. favourited exercises) before writing to [AppSettings.fileSettings]
  Map<String, List<String>> mapSettingsBck = new Map<String, List<String>>();

  TextEditingController _searchQuery;
  bool _isSearching = false;

  _AppBarSearchState(MuscleGroup muscleGroup, String title) {
    this.muscleGroup = muscleGroup;
    this.title = title;
    globals.currentScreen == "DisplayExercises"
        ? this.dataEx = muscleGroup.listExercisesMuscleGroup
        : this.dataEx = muscleGroup.getFavouriteExercises();
  }

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: globals.appBarBoxDecoration,
      ),
      key: _scaffoldKey,
      leading: _isSearching
          ? new BackButton(
              color: Colors.white,
            )
          : null,
      title: _isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    );
  }

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
    muscleGroup.listExercisesToDisplay.addAll(dataEx);
    widget.refresh();
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      _updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              title,
              style: new TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns textField in which text for exercise name filtering is entered.
  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: _updateSearchQuery,
    );
  }

  void _updateSearchQuery(String newQuery) {
    muscleGroup.listExercisesToDisplay.clear();
    if (newQuery.length > 0) {
      Set set = Set.from(dataEx);
      set.forEach((element) => _filterList(element, newQuery));
    }

    if (newQuery.isEmpty) {
      muscleGroup.listExercisesToDisplay.addAll(dataEx);
    }
    widget.refresh();
  }

  void _filterList(Exercise exercise, String searchQuery) {
    setState(() {
      if (exercise.name.toLowerCase().contains(searchQuery) || exercise.name.contains(searchQuery)) {
        muscleGroup.listExercisesToDisplay.add(exercise);
      }
    });
  }

  /// Builds and returns List of widgets for App bar.
  ///
  /// If searching is not enabled it returns search icon and 'favourite all' icon.
  /// If searching is enabled it returns
  List<Widget> _buildActions() {
    if (!_isSearching) {
      // Searching is OFF
      return <Widget>[
        new IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: _startSearch,
        ),
        Builder(builder: (BuildContext context) {
          /// Heart icon next to search icon for adding or removing all exercises from favourites.
          return IconButton(
            icon: Icon((muscleGroup.mapSettings['favouritesID'].length == 0) ? Icons.favorite_border : Icons.favorite),
            onPressed: () {
              // To undo the change
              mapSettingsBck = {'favouritesID': []};
              mapSettingsBck['favouritesID'].addAll(muscleGroup.mapSettings['favouritesID']);

              // Add all exercises to favourites (if current screen is not DisplayFavourites)
              if (muscleGroup.mapSettings['favouritesID'].length == 0) {
                if (!_isFavouritesScreen()) {
                  muscleGroup.fillFavourites(muscleGroup.listExercisesToDisplay);
                }
              } else {
                muscleGroup.removeFavouritedIDsFromDisplayedEx();

                // If the screen is DisplayFavourites, remove exercises from screen too
                if (_isFavouritesScreen()) {
                  // For undoing the un favouriting of the exercises
                  dataExBck.clear();
                  dataExBck.addAll(muscleGroup.listExercisesToDisplay);

                  muscleGroup.listExercisesToDisplay.clear();
                  widget.refresh();
                }
                // Trigger Snack Bar to undo change
                if (mapSettingsBck['favouritesID'].length != muscleGroup.listExercisesToDisplay.length) {
                  Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: Text('Favourites reset'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        muscleGroup.mapSettings['favouritesID'].addAll(mapSettingsBck['favouritesID']);
                        muscleGroup.writeSettingsToAssets();

                        // display undone changes in real time
                        if (_isFavouritesScreen() && muscleGroup.listExercisesToDisplay.length == 0) {
                          muscleGroup.listExercisesToDisplay.addAll(dataExBck);
                        }
                        widget.refresh();
                      },
                    ),
                  ));
                }
              }
              widget.refresh();
            },
          );
        }),
        // overflow menu
      ];
    }
    // Searching is ON
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          if (_searchQuery == null || _searchQuery.text.isEmpty) {
            Navigator.pop(context);
            return;
          }
          _clearSearchQuery();
        },
      ),
    ];
  }

  /// Returns true if current screen is DisplayFavourites.
  bool _isFavouritesScreen() {
    return (globals.currentScreen == "DisplayFavourites");
  }
}
