import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupstudy/constants/routes.dart';
import 'package:groupstudy/cubit/authentication/userauth_cubit.dart';
import 'package:groupstudy/cubit/groups/creategroup_cubit.dart';
import 'package:groupstudy/cubit/groups/joingroup_cubit.dart';
import 'package:groupstudy/cubit/screens/screenmanager_cubit.dart';
import 'package:groupstudy/presentation/screens/home.dart';
import 'package:groupstudy/presentation/screens/wrapper.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';

class AppRouter {
  late AuthRepository authRepo;
  late DatabaseRepository dataRepo;
  late UserAuthCubit userAuthCubit;

  AppRouter(
      {required this.authRepo,
      required this.dataRepo,
      required this.userAuthCubit});

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => 
            MultiBlocProvider(
            providers: [
              BlocProvider.value(value: userAuthCubit),
              BlocProvider(
                  create: (context) => ScreenManagerCubit(
                      currentScreen: MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => CreateGroupCubit(
                        auth: authRepo,
                        database: dataRepo
                      )),
                      BlocProvider(create: (context) => JoinGroupCubit(
                        auth: authRepo,
                        database: dataRepo
                      ))
                    ],
                    child: HomeScreen(),
                  )),
                )
            ], child: WrapperScreen(),
        )
        );
    }
  }
}
