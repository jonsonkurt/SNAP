import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:snap/model/database_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Enter your name',
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.green),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null; // Return null if there is no error
                            },
                          ),
                          const SizedBox(height: 20),
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
                                return 'Please enter a valid email';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null; // Return null if there is no error
                            },
                            keyboardType: TextInputType.emailAddress,
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
                                return 'Please enter a password';
                              }
                              return null; // Return null if there is no error
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Re-enter your password',
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.green),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null; // Return null if there is no error
                            },
                          ),
                          const SizedBox(height: 25),
                          OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String name = nameController.text;
                                String email = emailController.text;
                                String password = passwordController.text;
                                DatabaseHelper.instance.insertUser(
                                    name: name,
                                    email: email,
                                    password: password);
                                // clear the form fields
                                nameController.text = '';
                                emailController.text = '';
                                passwordController.text = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Account created')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Text(
                              "    SIGN UP    ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Already have an account? Sign In",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
