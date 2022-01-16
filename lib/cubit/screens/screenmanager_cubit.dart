import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'screenmanager_state.dart';

class ScreenManagerCubit extends Cubit<ScreenManagerState> {
  late Widget currentScreen;

  ScreenManagerCubit({required this.currentScreen}) : super(ScreenManagerInitial());

  void switchScreen(Widget screen) {
    this.currentScreen = screen;
    emit(ScreenChanged());
  }
}
