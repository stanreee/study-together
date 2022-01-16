part of 'creategroup_cubit.dart';

@immutable
abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class CreatingGroup extends CreateGroupState {}

class CreateGroupError extends CreateGroupState {
  String error;

  CreateGroupError({required this.error});
}
