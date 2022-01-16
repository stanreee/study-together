part of 'screenmanager_cubit.dart';

@immutable
abstract class ScreenManagerState {}

class ScreenManagerInitial extends ScreenManagerState {}

class ScreenChanged extends ScreenManagerState {}
