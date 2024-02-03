import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:flutter_application_1/components/square_tile.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final log = Logger('RegisterPage');
  // sign user up method
  void signUserUp() async {
    //print("Showing signup ...");
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        final authService = Provider.of<AuthService>(context, listen: false);
        UserCredential userCredential =
            await authService.signUpWithEmailAndPassword(
                emailController.text, passwordController.text);
        log.fine("created user ${userCredential}");
      } else {
        //print("passwords don't match");
        showErrorMessage("Passwords Don't Match");
      }
      // pop the loading circle
      Navigator.pop(context);
    } catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      showErrorMessage(e.toString());
    }
  }

  // wrong password message popup
  void showErrorMessage(String message) {
    log.fine("showing error message $message");
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              "Error",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              //logo
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //border: Border.all(
                  //    color: Theme.of(context).colorScheme.secondaryContainer),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: Icon(Icons.lock,
                    size: 70, color: Theme.of(context).colorScheme.primary),
              ),

              const SizedBox(height: 25),

              // welcome back, you've been missed!
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Sign Up",
                onTap: signUserUp,
              ),

              const SizedBox(height: 25),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                      onTap: () {}, //=> AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png'),

                  const SizedBox(width: 25),

                  // apple button
                  SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png')
                ],
              ),

              const SizedBox(height: 25),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
