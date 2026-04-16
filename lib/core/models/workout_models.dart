import 'package:flutter/material.dart';

class Workout {
  final String title;
  final String subtitle;
  final String level;
  final int durationMinutes;
  final int totalExercises;
  final int calories;
  final String heroImageUrl;
  final List<WorkoutPhase> phases;

  Workout({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.durationMinutes,
    required this.totalExercises,
    required this.calories,
    required this.heroImageUrl,
    required this.phases,
  });
}

class WorkoutPhase {
  final int phaseNumber;
  final String title;
  final List<Exercise> exercises;

  WorkoutPhase({
    required this.phaseNumber,
    required this.title,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final String imageUrl;
  final String? description;
  final String? duration;
  final int? reps;
  final int? sets;
  final String? weight;
  final String? focusLevel;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.imageUrl,
    this.description,
    this.duration,
    this.reps,
    this.sets,
    this.weight,
    this.focusLevel,
    this.isCompleted = false,
  });
}
