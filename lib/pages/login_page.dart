import 'package:chatly/services/auth/auth_services.dart';
import 'package:chatly/components/my_button.dart';
import 'package:chatly/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  //? Email & Password Controllers -- 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  //? tap to go to register page -- 
  final void Function()? onTap;
  
  LoginPage({
    super.key,
    required this.onTap,
  });

  //? Login Method --
  void login(BuildContext context) async {
    // auth services
    final authServices = AuthServices();

    // try login
    try {
      await authServices.signInWithEmailPassword(
         _emailController.text,
         _passwordController.text
         );
    }
    // catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: Text(e.toString()),
        )
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //! Logo ---
          Icon(
            Icons.message,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 50,),
          
          //! Welcome message --
          Text(
            "Welcome Back <3",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25,),

          //! Email textfield --
           MyTextfield(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 25,),

          //! Password textfield --
            MyTextfield(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(height: 25,),

          //! Login Button --
          MyButton(
            text: "Login", 
            onTap: ()=> login(context),
          ),

          const SizedBox(height: 25,),

          //! Register now --
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
               GestureDetector(
                onTap: onTap,
                 child: Text(
                  "Register now",
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