import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupstudy/cubit/groups/joingroup_cubit.dart';
import 'package:groupstudy/cubit/screens/screenmanager_cubit.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/presentation/screens/group.dart';
import 'package:groupstudy/widgets/button.dart';
import 'package:groupstudy/widgets/textfield.dart';

class JoinGroupScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  JoinGroupScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JoinGroupCubit joinGroupCubit = BlocProvider.of<JoinGroupCubit>(context);
    ScreenManagerCubit screenManagerCubit = BlocProvider.of<ScreenManagerCubit>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ThemeTextField(
              controller: _controller,
              hintText: "Enter five letter code...",
              maxLength: 5
            ),
            SizedBox(height: 10),
            ThemeButton(
              label: "Join session",
              onTap: () async {
                Group? group = await joinGroupCubit.joinGroup(_controller.text);
                if(group == null) return;
                Navigator.pop(context);
                BlocProvider.of<ScreenManagerCubit>(context)
                      .switchScreen(GroupScreen(group: group, isOwner: false, database: joinGroupCubit.database, authRepository: joinGroupCubit.auth,));
              }
            ),
          ]
        )
      ),
    );
  }
}