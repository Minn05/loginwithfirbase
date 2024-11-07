import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_demo/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:login_firebase_demo/screens/auth/components/my_text_field.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                //email field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    // errorMessage: _errorMessage,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid field';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                //password field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    // errorMessage: _errorMessage,

                    onChanged: (value) {
                      setState(() {
                        if (value!.contains(RegExp(r'[A-Z]'))) {
                          containsUpperCase = true;
                        }

                        if (value.contains(RegExp(r'[a-z]'))) {
                          containsLowerCase = true;
                        }

                        if (value.contains(RegExp(r'[0-9]'))) {
                          containsNumber = true;
                        }

                        if (value.contains(RegExp(
                            r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                          containsSpecialChar = true;
                        }

                        if (value.length >= 8) {
                          contains8Length = true;
                        }
                      });
                      return null;
                      // return null;
                    },
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                            if (obscurePassword) {
                              iconPassword = Icons.remove_red_eye_rounded;
                            } else {
                              iconPassword = CupertinoIcons.eye_slash_fill;
                            }
                          });
                        },
                        icon: Icon(iconPassword)),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$")
                          .hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "●  1 uppercase",
                            style: TextStyle(
                                color: containsUpperCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            "●  1 lowercase",
                            style: TextStyle(
                                color: containsLowerCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            "●  1 number",
                            style: TextStyle(
                                color: containsNumber
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "●  1 special character",
                            style: TextStyle(
                                color: containsSpecialChar
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            "●  8 minium character",
                            style: TextStyle(
                                color: contains8Length
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //name field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    // errorMessage: _errorMessage,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (val.length > 30) {
                        return 'Name too long';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //SignUp Button
                !signUpRequired
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              MyUser myUser = MyUser.empty;
                              myUser = myUser.copyWith(
                                email: emailController.text,
                                name: nameController.text,
                              );
                              setState(() {
                                context.read<SignUpBloc>().add(SignUpRequired(
                                    user: myUser,
                                    password: passwordController.text));
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            elevation: 3,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
