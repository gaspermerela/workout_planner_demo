import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Logic/Exercise.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Data/AppSettings.dart';
//import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class ExercisesListView extends StatefulWidget {
  final String title;
  final Function refresh;
  final MuscleGroup muscleGroup;

  const ExercisesListView({this.title, Key key, this.refresh, this.muscleGroup}) : super(key: key);

  @override
  _ExercisesListViewState createState() => _ExercisesListViewState(title, muscleGroup);
}

class _ExercisesListViewState extends State<ExercisesListView> {
  final AppSettings settings = new AppSettings();

  MuscleGroup muscleGroup;
  String title;

  List<Exercise> dataEx;

  /// Storing exercise removed from display when unfavouriting an exercise.
  ///
  /// When displaying favorites unfavourited exercise disappears from screen - is removed from [MuscleGroup.listExercisesToDisplay].
  /// If we want to undo that change we have to store previously displayed exercise.
  // TODO Implementation to undo ONE exercise implemented as a LIST ??
  List<Exercise> dataBckEx = new List<Exercise>();

  int previousID = -1;
  int previousIndex = 0;

  Color color;
  bool _isFavorited;

  _ExercisesListViewState(String title, MuscleGroup muscleGroup) {
    this.title = title;
    this.muscleGroup = muscleGroup;

    muscleGroup.changeDisplayedExercises();
    dataEx = muscleGroup.listExercisesToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.75;

    return Container(
        decoration: globals.boxDecoration,
        child: ListView.builder(
          itemCount: dataEx.length,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                // add children icon for adding exercises to workout
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: c_width,
                    child: new Text(
                      '${dataEx[index].name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: getColor(dataEx[index].diff),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(dataEx[index].link)) {
                      await launch(dataEx[index].link);
                    } else {
                      throw "Could not launch ${dataEx[index].link}";
                    }
                  },
                  // TODO - shorten empty space below ok button
                  // NOTE - in order for gif display to work data set with gifLinks has to be used
                  onLongPress: () async {
//                    Image img;
//                    try {
//                      img = Image.asset(
//                          "assets/gifs/${dataEx[index].exID}_${dataEx[index].name.replaceAll(" ", "_")}.gif",
//                          scale: 0.6);
//                    } catch (_) {
//                      img = new Image.network(
//                        dataEx[index].linkGif,
//                        scale: 0.6,
//                      );
//                    }
//
//                    if (img != null)
//                      showDialog(
//                          context: context,
//                          // Using hijacked and slightly changed GiffyDialog package.
//                          builder: (_) => NetworkGiffyDialog(
//                                image: img,
//                                title: Text(dataEx[index].name,
//                                    textAlign: TextAlign.center,
//                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800)),
//                                entryAnimation: EntryAnimation.DEFAULT,
//                                onlyOkButton: true,
//                                buttonOkText: new Text('Ok, got it!'),
//                                onOkButtonPressed: () {
//                                  Navigator.of(context).pop();
//                                },
//                              ));
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(),
                    child: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
//                        showDialog(
//                          context: context,
//                          builder: (BuildContext context) => new ExerciseInfoDialog(dataEx[index]),
//                        );
                      },
                    )),
                buildFavIcon(
                  index,
                ),
              ],
            );
          },
        ));
  }

  Color getColor(String diff) {
    if (diff == "1") {
      color = Colors.green;
    } else if (diff == "2") {
      color = Colors.orange;
    } else if (diff == "\\") {
      color = Colors.black;
    } else {
      color = Colors.red;
    }
    return color;
  }

  /// Builds favourite Icon for each exercise.
  ///
  /// If the exercise is favourited the Icon is full heart otherwise it is empty heart.
  /// When the Favourite icon is pressed a [_toggleFavorite] method is called.
  Container buildFavIcon(int index) {
    _isFavorited = muscleGroup.isExerciseFavourited(dataEx[index]);
    //_getMatches(muscleGroup.getAllFavouritesIDs(), dataEx[index].exID);
    return Container(
      padding: EdgeInsets.all(0),
      child: IconButton(
          icon: (_isFavorited ? Icon(Icons.favorite_border) : Icon(Icons.favorite)),
          color: Colors.red[500],
          onPressed: () {
            _toggleFavorite(index);
          }),
    );
  }

  /// Adds or removes exercise id from favourites and changes the outline of the Favourite icon.
  ///
  /// If current screen is DisplayFavourites Undo option of unfavourited exercise is implemented.
  void _toggleFavorite(int index) async {
    _isFavorited = muscleGroup.isExerciseFavourited(dataEx[index]);
    //_getMatches(muscleGroup.getAllFavouritesIDs(), dataEx[index].exID);
    setState(() {
      if (_isFavorited) {
        // First press
        // Add exercise id to List mapSettings['favouritesID'].
        muscleGroup.addFavouritedID(dataEx[index].exID);

        // refresh parent screen
        widget.refresh();

        _isFavorited = false;
      } else {
        // Second press
        previousID = int.parse(dataEx[index].exID);
        previousIndex = index;

        // Remove exercise id from List mapSettings['favouritesID'].
        muscleGroup.removeFavouritedID(dataEx[index].exID);

        // In DisplayFavourites exercise disappears from the screen when it is unfavourited.
        // Because of this the Undo functionality is implemented.
        // TODO - unfavouriting of multiple exercises one after another starts the “undo popup option” for every unfoavourited exercise.
        if (_isFavouritesScreen()) {
          dataBckEx.clear();
          dataBckEx.add(dataEx[index]);

          dataEx.removeAt(index);

          Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: Text('Favourites reset'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  muscleGroup.addFavouritedID(previousID.toString());
                  dataEx.insert(previousIndex, dataBckEx[0]);
                });
              },
            ),
          ));
        }

        // refresh parent screen
        widget.refresh();

        _isFavorited = true;
      }
    });
  }

  bool _isFavouritesScreen() {
    return (globals.currentScreen == "DisplayFavourites");
  }
}
