import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupstudy/constants/colours.dart';
import 'package:groupstudy/presentation/router.dart';
import 'package:groupstudy/repositories/auth/auth_repository.dart';
import 'package:groupstudy/repositories/database/database_repository.dart';

import 'cubit/authentication/userauth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthRepository authRepo = AuthRepository(firebaseAuth: auth);
  DatabaseRepository dataRepo = DatabaseRepository(firestore: firestore);

  runApp(Main(authRepo: authRepo, dataRepo: dataRepo));
}

class Main extends StatelessWidget {
  
  late AppRouter router;
  late UserAuthCubit userAuthCubit;

  final AuthRepository authRepo;
  final DatabaseRepository dataRepo;
  
  Main({ 
    Key? key,
    required this.authRepo,
    required this.dataRepo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    userAuthCubit = UserAuthCubit(authRepo: authRepo, dataRepo: dataRepo);
    router = AppRouter(authRepo: authRepo, dataRepo: dataRepo, userAuthCubit: userAuthCubit);

    return BlocProvider.value(
      value: userAuthCubit,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Roboto",
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w700, color: Color(PRIMARY_COLOR)),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute
      )
    );
  }
}

