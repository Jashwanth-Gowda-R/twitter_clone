import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // to avoid rebuilding
  final appBar = UIConstants.appBar();
  // text fields
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                AuthField(
                  controller: _email,
                  hint: 'Email',
                ),
                const SizedBox(
                  height: 25,
                ),
                AuthField(
                  controller: _password,
                  hint: 'Password',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
