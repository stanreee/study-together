import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupstudy/cubit/authentication/userauth_cubit.dart';
import 'package:groupstudy/cubit/groups/creategroup_cubit.dart';
import 'package:groupstudy/cubit/groups/joingroup_cubit.dart';
import 'package:groupstudy/cubit/screens/screenmanager_cubit.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/presentation/screens/group.dart';
import 'package:groupstudy/presentation/screens/join_group.dart';
import 'package:groupstudy/presentation/screens/signin.dart';
import 'package:groupstudy/presentation/screens/signup.dart';
import 'package:groupstudy/widgets/button.dart';
import 'package:groupstudy/widgets/textfield.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController _displayName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserAuthCubit userAuthCubit = BlocProvider.of<UserAuthCubit>(context);
    CreateGroupCubit createGroupCubit =
        BlocProvider.of<CreateGroupCubit>(context);
    JoinGroupCubit joinGroupCubit = BlocProvider.of<JoinGroupCubit>(context);
    ScreenManagerCubit screenManagerCubit =
        BlocProvider.of<ScreenManagerCubit>(context);
    userAuthCubit.checkUserSetup();

    return BlocBuilder<UserAuthCubit, UserAuthState>(builder: (context, state) {
      if (state is UserAuthInitial || state is UserAuthenticating) {
        return Center(child: CircularProgressIndicator());
      }

      if (state is UserUnauthenticated) {
        return _signUpOrSignIn(context, userAuthCubit);
      }

      if (state is UserNotInDatabase) {
        return _enterDisplayName(userAuthCubit);
      }

      if (state is UserAuthError) {
        Fluttertoast.showToast(
          msg: state.error,
          fontSize: 12,
        );
        return _signUpOrSignIn(context, userAuthCubit);
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemeButton(
                label: "Start a session",
                onTap: () async {
                  Group? group = await createGroupCubit.createGroup();
                  if (group == null) {
                    Fluttertoast.showToast(
                      msg: "Error starting session.",
                      fontSize: 12,
                    );
                    return;
                  }
                  BlocProvider.of<ScreenManagerCubit>(context)
                      .switchScreen(GroupScreen(
                    group: group,
                    isOwner: true,
                    database: userAuthCubit.dataRepo,
                    authRepository: userAuthCubit.authRepo,
                  ));
                }),
            ThemeButton(
                label: "Join a session",
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: joinGroupCubit),
                          BlocProvider.value(value: screenManagerCubit)
                        ],
                        child: JoinGroupScreen(),
                      ),
                      transitionDuration: Duration.zero,
                    ),
                  );
                  // BlocProvider.of<ScreenManagerCubit>(context)
                  //     .switchScreen(BlocProvider(
                  //   create: (context) => JoinGroupCubit(),
                  //   child: JoinGroupScreen(),
                  // ));
                }),
          ],
        ),
      );
    });
  }

  Widget _signUpOrSignIn(context, UserAuthCubit userAuthCubit) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/start_page.png"), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Study Together",
                  style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 325.0),
              ThemeButton(label: "LOGIN", onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: userAuthCubit,
                          child: SignInScreen(),
                        ),
                      ),
                    );
              }),
              SizedBox(height: 30.0),
              ThemeButton(
                  label: "SIGN UP",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<UserAuthCubit>(context),
                          child: SignupScreen(),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }

  Widget _signUp(UserAuthCubit userAuthCubit) {
    return Center(
        child: Column(children: [
      ThemeTextField(
          controller: _email,
          textInputType: TextInputType.emailAddress,
          hintText: "Enter your email"),
      ThemeTextField(
          controller: _password,
          obscureText: true,
          hintText: "Enter your password"),
      ThemeTextField(
          controller: _displayName, hintText: "Enter your display name"),
      ThemeButton(
          label: "Create account",
          onTap: () {
            userAuthCubit.createUser(
                _email.text, _password.text, _displayName.text);
          }),
    ]));
  }

  Widget _enterDisplayName(UserAuthCubit userAuthCubit) {
    return Center(
        child: Column(
      children: [
        Expanded(
            child: ThemeTextField(
                controller: _displayName,
                hintText: "Enter display name...",
                textInputType: TextInputType.emailAddress))
      ],
    ));
  }
}
