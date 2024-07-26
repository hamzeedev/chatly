import 'package:chatly/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  //* Email & Password Controllers --
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  //* ontap go to login page
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  //? Register Method --
  void register(BuildContext context) {
    //* get auth service
    final auth = AuthServices();

    //* password match -> create user
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
    //* password dont match -> tell user to fix
    else {
      showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Password don't match!"),
                ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //! Logo ---
          Icon(
            Icons.message,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(
            height: 50,
          ),

          //! Welcome message --
          Text(
            "Let's create an account",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          //! Email textfield --
          MyTextfield(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(
            height: 20,
          ),

          //! Password textfield --
          MyTextfield(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(
            height: 20,
          ),

          //! Confirm Password textfield --
          MyTextfield(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _confirmPasswordController,
          ),

          const SizedBox(
            height: 20,
          ),

          //! Register Button --
          MyButton(
            text: "Register",
            onTap: () => register(context),
          ),

          const SizedBox(
            height: 20,
          ),

          //! Register now --
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login now!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.blue
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
