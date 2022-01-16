import 'package:bloc/bloc.dart';
import 'package:groupstudy/cubit/authentication/userauth_cubit.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'creategroup_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final AuthRepository auth;
  final DatabaseRepository database;

  CreateGroupCubit({
    required this.auth,
    required this.database
  }) : super(CreateGroupInitial());

  Future<Group?> createGroup() async {
    emit(CreatingGroup());
    try{
      String code = await database.generateUniqueCode();
      Group g = Group(groupCode: code, users: [], distractedUsers: []);
      await database.createGroup(g);
      AppUser user = await auth.getAppUser();
      await database.joinGroup(code, user);
      return g;
    } on Exception catch(_) {
      emit(CreateGroupError(error: "Error creating group."));
    }
  }
}
