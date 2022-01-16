import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupstudy/cubit/authentication/userauth_cubit.dart';
import 'package:groupstudy/cubit/screens/screenmanager_cubit.dart';
import 'package:groupstudy/widgets/button.dart';
import 'package:groupstudy/widgets/textfield.dart';

class SignInScreen extends StatelessWidget {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserAuthCubit userAuthCubit = BlocProvider.of<UserAuthCubit>(context);
    debugPrint(userAuthCubit.state.toString());
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<UserAuthCubit, UserAuthState>(
        builder: (context, state) {
          if(state is UserAuthError) {

          }

          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/sign_up_page.png"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  ThemeTextField(
                    controller: _email,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Enter your email",
                    height: 55,
                    width: 275,
                  ),
                  SizedBox(height: 20.0),
                  ThemeTextField(
                    controller: _password,
                    obscureText: true,
                    hintText: "Enter your password",
                    height: 55,
                    width: 275,
                  ),
                  SizedBox(height: 20.0),
                  ThemeButton(
                    label: "Sign in",
                    onTap: () async {
                      await userAuthCubit.signIn(_email.text, _password.text);
                      Navigator.pop(context);
                    },
                    width: 200,
                  ),
                ])),
          );
        },
      ),
    );
  }
}
