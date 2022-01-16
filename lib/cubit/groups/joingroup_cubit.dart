import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'joingroup_state.dart';

class JoinGroupCubit extends Cubit<JoinGroupState> {

  final DatabaseRepository database;
  final AuthRepository auth;

  JoinGroupCubit({required this.database, required this.auth}) : super(JoinGroupInitial());

  Future<Group?> joinGroup(String groupCode) async {
    if(groupCode.isEmpty) {
      emit(JoinError(error: "Please enter the five letter group code."));
      return null;
    }
    emit(JoiningGroup());
    try {
      AppUser user = await auth.getAppUser();
      Group group = await database.joinGroup(groupCode, user);
      return group;
    } on Exception catch(e) {
      debugPrint(e.toString());
      emit(JoinError(error: "Error joining group."));
    }
  }
}
