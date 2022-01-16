part of 'userauth_cubit.dart';

@immutable
abstract class UserAuthState {}

class UserAuthInitial extends UserAuthState {}

class UserAuthenticating extends UserAuthState {}

class UserNotInDatabase extends UserAuthState {}

class UserUnauthenticated extends UserAuthState {}

class UserAuthError extends UserAuthState {
  String error;
  
  UserAuthError({required this.error});
}

class UserAuthenticated extends UserAuthState {}
