import 'package:flutter/material.dart';
import 'package:advanced_workout_planner/Logic/MuscleGroup.dart';
import 'dart:ui';
import 'package:advanced_workout_planner/Display/DisplayFavourites.dart';
import 'package:advanced_workout_planner/Globals.dart' as globals;

class AppDrawer extends StatefulWidget {
  MuscleGroup muscleGroup;

  AppDrawer(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
  }

  @override
  _AppDrawerState createState() => new _AppDrawerState(muscleGroup);
}

class _AppDrawerState extends State<AppDrawer> {
  // TODO access to asset files implement differently - Globals!
  MuscleGroup muscleGroup;

  _AppDrawerState(MuscleGroup muscleGroup) {
    this.muscleGroup = muscleGroup;
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width * 0.55, //20.0,
      child: Drawer(
          child: Stack(children: <Widget>[
        Container(
          decoration: globals.drawerBoxDecoration,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, bottom: 15, top: 75),
                          width: 120,
                          child: ClipRRect(
                            // TODO - Use downloaded image or find suitable Icon
                            child: Image.asset("assets/images/menu.png"),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Text(
                          "Menu",
                          style: TextStyle(color: Colors.white, fontSize: 34),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context, new MaterialPageRoute(builder: (context) => new DisplayFavourites(muscleGroup)));
                      },
                      title: Text(
                        "Favourites",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.all_out,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ])),
    );
  }
}
