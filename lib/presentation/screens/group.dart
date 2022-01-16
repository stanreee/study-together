import 'package:flutter/material.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';
import 'package:wakelock/wakelock.dart';

class GroupScreen extends StatelessWidget with WidgetsBindingObserver {
  final Group group;
  final bool isOwner;
  final DatabaseRepository database;
  final AuthRepository authRepository;

  GroupScreen({ Key? key, required this.group, required this.isOwner, required this.database, required this.authRepository }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addObserver(this);
    Wakelock.enable();
    return Container(
      child: Center(child: Text(group.groupCode))
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        debugPrint("test resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("test inactive");
        //database.setDistracted(group, authRepository.getFirebaseUser()!.uid);
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }
}