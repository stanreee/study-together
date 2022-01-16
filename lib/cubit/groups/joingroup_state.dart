part of 'joingroup_cubit.dart';

@immutable
abstract class JoinGroupState {}

class JoinGroupInitial extends JoinGroupState {}

class JoiningGroup extends JoinGroupState {}

class JoinError extends JoinGroupState {
  String error;

  JoinError({required this.error});
}
