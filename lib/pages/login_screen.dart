import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messageme_app/cubit/cubit.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/pages/register_screen.dart';
import 'package:messageme_app/shared/components.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_screen.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "Login Screen";
  final _auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: ModalProgressHUD(
                inAsyncCall: cubit.showingSpinner,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'images/vector.jpg',
                              height: 180,
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                controller: emailController,
                                validator: (String? value) {
                                  if (!value!.contains('@')) {
                                    return 'worng email';
                                  }
                                }
                                ),
                            const SizedBox(height: 10),
                            MyTextField(label: 'Password',
                                icon: Icons.lock_outlined,
                                hidePassword: true,
                                controller: passwordController,
                                validator: (String? value) {
                                  if (value!.length < 6) {
                                    return 'the password is very small';
                                  }
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              color: Colors.blue[800],
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    cubit.showingSpinnerMethod();
                                    final user =
                                        await _auth.signInWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
                                    if (user != null) {
                                      Navigator.pushReplacementNamed(
                                          context, ChatScreen.routeName);
                                    }
                                  } catch (e) {
                                    cubit.nonshowingSpinnerMethod();
                                    print(' the error ======= :${e.toString()}');
                                    cubit.showingInvalid("The password is invalid or the user does not have a password.");
                                  }
                                }
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              cubit.invalid,
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text("I don't have an account ?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
