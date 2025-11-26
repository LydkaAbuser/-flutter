import 'package:flutter/material.dart';

@immutable
abstract class MainScreenState {}

class MainScreenInitial extends MainScreenState {}

class MainScreenCalculated extends MainScreenState {
  final double initialVelocity;
  final double finalVelocity;
  final double time;
  final double acceleration;
  final String movementType;

  MainScreenCalculated({
    required this.initialVelocity,
    required this.finalVelocity,
    required this.time,
    required this.acceleration,
    required this.movementType,
  });
}

class MainScreenError extends MainScreenState {
  final String message;

  MainScreenError(this.message);
}