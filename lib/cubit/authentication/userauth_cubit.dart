import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/exceptions/exceptions.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'userauth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {

  final AuthRepository authRepo;
  final DatabaseRepository dataRepo;

  UserAuthCubit({
    required this.authRepo,
    required this.dataRepo
  }) : super(UserAuthInitial());

  Future<void> checkUserSetup() async {
    emit(UserAuthenticating());
    if(!authRepo.isAuthenticatedWithFirebase()) {
      emit(UserUnauthenticated());
      return;
    }
    User user = authRepo.getFirebaseUser()!;
    bool setup = await dataRepo.userInDatabase(user);
    if(!setup) {
      emit(UserNotInDatabase());
      return;
    }
    emit(UserAuthenticated());
  }

  Future<void> createUser(String email, String password, String displayName) async {
    if(email.isEmpty) {
      emit(UserAuthError(error: "Please enter an email address."));
      return;
    }else if(password.isEmpty) {
      emit(UserAuthError(error: "Please enter a password."));
      return;
    }else if(displayName.isEmpty) {
      emit(UserAuthError(error: "Please enter a display name."));
      return;
    }
    emit(UserAuthenticating());
    try{ 
      User? user = await authRepo.createUser(email, password);
      debugPrint(user.toString());
      await dataRepo.createUser(user!, displayName);
      emit(UserAuthenticated());
    } on UserAuthException catch(e) {
      emit(UserAuthError(error: e.toString()));
      emit(UserUnauthenticated());
    } on Exception catch(_) {
      emit(UserAuthError(error: "Error creating user."));
      emit(UserUnauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    if(email.isEmpty) {
      emit(UserAuthError(error: "Please enter an email address."));
      return;
    }else if(password.isEmpty) {
      emit(UserAuthError(error: "Please enter a password."));
      return;
    }
    try{
      await authRepo.signIn(email, password);
      emit(UserAuthenticated());
    } on Exception catch(e) {

    }
  }

  Future<void> logOut() async {
    await authRepo.signOut();
    emit(UserUnauthenticated());
  }
}
