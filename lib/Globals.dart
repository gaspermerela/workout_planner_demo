library globals;

import 'package:flutter/material.dart';

/// File [Globals.dart] contains:
/// Maps of names and hyperlinks
/// Hyperlink to exercise properties explanation
/// Explanation of each exercise property
///
/// Map containing muscle group and subgroup names [mapMuscleGroupIDToStringENG]
/// Map containing hyperlinks to muscle group and subgroup explanation [mapMuscleGroupUrl]
/// Map containing hyperlinks to muscle group and subgroup pictures [mapMuscleGroupUrlPicture]

/// Tracking which screen is currently used.
///
/// Current screens to track: DisplayExercises, DisplayFavourites

// TODO - exercises, exercise names, links, descriptions, from database

String currentScreen = "";

final String settingsFilename = "settings.json";
final String sExercisesFile = "assets/exercises.json"; // exercises data set without gifLinks

// Muscle Group Names
/// Contains all muscle group and subgroup names in English language if possible.
///
/// Keys: Muscle group IDs
/// Value: Muscle group names.
const Map<String, String> mapMuscleGroupIDToStringENG = {
  "1": "Shoulders",
  "1.1": "Deltoid",
  "1.1.1": "Front Delts",
  "1.1.2": "Side Delts",
  "1.1.3": "Rear Delts",
  "1.2": "Rotatory Cuff",

  "2": "Arms",
  "2.1": "Biceps",
  "2.1.1": "Biceps",
  "2.1.2": "Lower Biceps",
  "2.2": "Triceps",

  "3": "Forearms",
  "3.1": "Upper-Outer Forearms",
  "3.2": "Hand Flexor",
  "3.3": "Hand Extensor",

  "4": "Back",
  // Most back exercises are classified as "General back" - further classification?
  "4.1": "Generic Back",
  "4.2": "Upper Back",
  "4.2.1": "Traps",
  "4.2.2": "Levator Scapulae",
  "4.2.3": "Middle Trapezius", // no exercises set - trap, general back exercises
  "4.3": "Middle Back",
  "4.3.1": "Lower Traps", // no exercises set - lat, general back exercises
  "4.3.2": "Rhomboids", // no exercises set - lat, general back exercises
  "4.3.3": "Lats",
  "4.3.4": "Teres Major", // Teres Major - Lats little helper
  "4.4": "Rotatory Cuff",
  "4.4.1": "Infraspinatus",
  "4.4.2": "Teres minor",
  "4.4.3": "Subscapularis",

  "5": "Chest",
  "5.1": "Lower Chest",
  "5.2": "Upper Chest",
  "5.3": "Pectoralis Minor",
  "5.4": "Serratus Anterior",

  "6": "Core",
  "6.1": "Abs",
  "6.2": "Obliques",
  "6.3": "Lower Back",

  "7": "Legs",
  "7.1": "Hips",
  "7.1.1": "Gluteus Maximus",
  "7.1.2": "Hip Abductors",
  "7.1.3": "Hip Flexors",
  "7.1.4": "Deep Hip External Rotators",
  "7.2": "Thigs",
  "7.2.1": "Quadriceps",
  "7.2.2": "Hamstrings",
  "7.2.3": "Hip Adductors",
  "7.3": "Calves",
  "7.3.1": "General or Gastrocnemius",
  "7.3.2": "Soleus",
  "7.3.3": "Tibialis Anterior",
};

// Muscle Group HyperLinks
/// Contains muscle group and subgroup hyperlinks to additional learning sources.
///
/// Keys: Muscle group IDs
/// Value: Hyperlink to a web page.
const Map<String, String> mapMuscleGroupUrl = {
  // Shoulders
  "1": "http://www.kingofthegym.com/shoulder-anatomy/", // Shoulders
  "1.1": "http://www.kingofthegym.com/shoulder-anatomy/", // Deltoid
  "1.1.1": "https://www.exrx.net/Muscles/DeltoidAnterior", // Front Delts
  "1.1.2": "https://www.exrx.net/Muscles/DeltoidLateral", // Side Delts
  "1.1.3": "https://www.exrx.net/Muscles/DeltoidPosterior", // Rear Delts
  "1.2": "https://www.exrx.net/Muscles/Supraspinatus", // Rotatory Cuff

  // Arms
  "2.1.1": "https://www.exrx.net/Muscles/BicepsBrachii", // Biceps
  "2.1.2": "https://www.exrx.net/Muscles/Brachialis", // Lower Biceps
  "2.2": "https://www.exrx.net/Muscles/TricepsBrachii", // Triceps

  // Forearms
  "3.1": "https://www.exrx.net/Muscles/Brachioradialis", // Upper-Outer Forearms
  "3.2": "https://www.exrx.net/Muscles/WristFlexors", // Hand Flexor
  "3.3": "https://www.exrx.net/Muscles/WristExtensors", // Hand Extensor

  // Back
  "4": "https://www.kingofthegym.com/back-anatomy/", // Back
  "4.2.1": "https://www.exrx.net/Muscles/TrapeziusUpper", // Traps
  "4.2.2": "https://www.exrx.net/Muscles/LevatorScapulae", // Levator Scapulae
  "4.2.3":
      "https://www.exrx.net/Muscles/TrapeziusMiddle", // Middle Trapezius (no exercises set - trap, general back exercises)
  "4.3.1":
      "https://www.exrx.net/Muscles/TrapeziusLower", // Lower Traps (no exercises set - lat, general back exercises)
  "4.3.2": "https://www.exrx.net/Muscles/Rhomboids", // Rhomboids (no exercises set - lat, general back exercises)
  "4.3.3": "https://www.exrx.net/Muscles/LatissimusDorsi", // Lats
  "4.3.4": "https://www.exrx.net/Muscles/TeresMajor", // Teres Major - Lats little helper
  "4.4.1": "https://www.exrx.net/Muscles/Infraspinatus", // Infraspinatus
  "4.4.2": "https://www.exrx.net/Muscles/TeresMinor", // Teres Minor
  "4.4.3": "https://www.exrx.net/Muscles/Subscapularis", // Subscapularis

  // Chest
  "5.1": "https://www.exrx.net/Muscles/PectoralisSternal", // Lower Chest
  "5.2": "https://www.exrx.net/Muscles/PectoralisClavicular", // Upper Chest
  "5.3": "https://exrx.net/Muscles/PectoralisMinor", // Pectoralis Minor
  "5.4": "https://exrx.net/Muscles/SerratusAnterior", // Serratus Anterior

  // Core
  "6.1": "https://exrx.net/Muscles/RectusAbdominis", // Abs
  "6.2": "https://exrx.net/Muscles/Obliques", // Obliques
  "6.3": "https://exrx.net/Muscles/ErectorSpinae", // Lower Back

  "7": "Legs",
  //"7.1": "Hips",
  "7.1.1": "https://exrx.net/Muscles/GluteusMaximus", // Gluteus Maximus
  "7.1.2": "https://www.kingofthegym.com/leg-anatomy/#Hip_Abductors", // Hip Abductors
  "7.1.3": "https://www.kingofthegym.com/leg-anatomy/#The_Hip_Flexors_Iliopsoas", // Hip Flexors
  "7.1.4": "https://exrx.net/Muscles/HipExernalRotators", // Deep Hip External Rotators
//  "7.2": "Thigs",
  "7.2.1": "https://www.exrx.net/Muscles/Quadriceps", // Quadriceps
  "7.2.2": "https://www.exrx.net/Muscles/Hamstrings", // Hamstrings
  "7.2.3": "https://www.kingofthegym.com/leg-anatomy/#Hip_Adductors", // Hip Adductors
//  "7.3": "Calves",
  "7.3.1": "https://www.exrx.net/Muscles/Gastrocnemius", // General or Gastrocnemius
  "7.3.2": "https://www.exrx.net/Muscles/Soleus", // Soleus
  "7.3.3": "https://www.exrx.net/Muscles/TibialisAnterior", // Tibialis Anterior
};

// General properties
const String sGeneralProperties = 'https://www.exrx.net/WeightTraining/Glossary';

// Properties explanation
// Utility
const String utilityBasicExplanationENG =
    'A principal exercise that can place greater absolute intensity on muscles exercised relative to auxiliary exercises. (bench press, squat, dead lift)';
const String utilityBasicExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Basic';

const String utilityAuxiliaryExplanationENG =
    'An optional exercise that may supplement a basic exercise. Auxiliary exercises may place greater relative intensity on a specific muscle or a head of a muscle.';
const String utilityAuxiliaryExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Auxiliary';

// Mechanics
const String mechanicsCompoundExplanationENG = 'An exercise that involves two or more joint movements.';
const String mechanicsCompoundExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Compound';

const String mechanicsIsolatedExplanationENG = 'An exercise that involves just one discernible joint movement.';
const String mechanicsIsolatedExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Isolated';

// Force
const String forcePushExplanationENG =
    'Movement away from center of body during the concentric contraction of the target muscle.';
const String forcePushExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Push';

const String forcePullExplanationENG =
    'Movement toward center of body during the concentric contraction of the target muscle.';
const String forcePullExplanationLink = 'https://www.exrx.net/WeightTraining/Glossary#Pull';

// BoxDecoration implementation using Themes ?
BoxDecoration boxDecoration = new BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    ColorTween(begin: Colors.purple[900], end: Colors.deepPurple[900]).lerp(0),
    ColorTween(
      begin: Colors.blue[900],
      end: Colors.blueGrey[200],
    ).lerp(0),
  ],
));

BoxDecoration appBarBoxDecoration = new BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.topLeft,
  colors: [
    ColorTween(begin: Colors.blueAccent, end: Colors.blueGrey[400]).lerp(0),
    ColorTween(begin: Colors.green, end: Colors.purple[900]).lerp(100),
  ],
));

BoxDecoration drawerBoxDecoration = new BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      ColorTween(
        begin: Colors.blueAccent,
        end: Colors.blue[400],
      ).lerp(1),
      ColorTween(
        begin: Colors.green,
        end: Colors.blueAccent.withGreen(80),
      ).lerp(1),
    ],
  ),
);
