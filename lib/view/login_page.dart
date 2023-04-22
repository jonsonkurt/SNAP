// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:snap/view/my_screen.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'package:snap/model/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            padding: const EdgeInsets.all(45),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  const SizedBox(height: 10),
                  const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Not registered yet? Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your email',
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.green),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null; // Return null if there is no error
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.green),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null; // Return null if there is no error
                            },
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage()),
                              );
                            },
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          OutlinedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = emailController.text;
                                String password = passwordController.text;
                                bool isUserExist = await DatabaseHelper.instance
                                    .isUserExist(email, password);

                                if (isUserExist) {
                                  final List<Map<String, dynamic>> result =
                                      await DatabaseHelper.instance.getUsers();
                                  final Map<String, dynamic> user = result
                                      .firstWhere((u) => u['email'] == email);
                                  int userId = user['id'];
                                  DatabaseHelper.loggedInUserId = userId;
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const MyScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = const Offset(0.0, 1.0);
                                        var end = Offset.zero;
                                        var curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Invalid email or password')),
                                  );
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Text(
                              "    SIGN IN    ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
