import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupstudy/cubit/authentication/userauth_cubit.dart';
import 'package:groupstudy/cubit/screens/screenmanager_cubit.dart';
import 'package:groupstudy/presentation/screens/group.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenManagerCubit screenManagerCubit = BlocProvider.of<ScreenManagerCubit>(context);
    UserAuthCubit userAuthCubit = BlocProvider.of<UserAuthCubit>(context);

    return BlocBuilder<ScreenManagerCubit, ScreenManagerState>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                ListTile(
                  title: Text("Log out"),
                  onTap: () async {
                    await userAuthCubit.logOut();
                  }
                ),
              ],
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent
          ),
          body: screenManagerCubit.currentScreen,
          extendBodyBehindAppBar: true,
        );
      },
    );
  }
}