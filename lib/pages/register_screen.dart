import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messageme_app/cubit/cubit.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/pages/chat_screen.dart';
import 'package:messageme_app/shared/components.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'login_screen.dart';



class RegisterScreen extends StatelessWidget {
  static String routeName = "Register Screen";

  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();

  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController confirmPasswordController =TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (__,_){},
        builder: (context,_){
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
                              validator: (String? value){
                                if(!value!.contains('@')){
                                  return 'wrong email';
                                }
                              }
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
                              hidePassword: true,
                              label: 'Password',
                              icon: Icons.lock_outlined,
                              controller: passwordController,
                              validator: (String? value){
                                if(value!.length < 6 ){
                                  return "very small password";
                                }
                              }
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            hidePassword: true,
                            label: 'Confirm Password',
                            icon: Icons.lock_outlined,
                            validator: (String? value){
                              if(passwordController.text != value|| value!.isEmpty){
                                return 'the password is not matched';
                              }
                            },
                            controller: confirmPasswordController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          myButton(
                              title: 'Register',
                              color: Colors.blue[800],
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    cubit.showingSpinnerMethod();
                                    await _auth.createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                    Navigator.pushReplacementNamed(
                                        context, ChatScreen.routeName);
                                  } catch (e) {
                                    cubit.nonshowingSpinnerMethod();
                                    cubit.showingInvalid(
                                        "The email address is already in use by another account."
                                    );
                                  }
                                }
                              }
                          ),
                          Text(
                          cubit.invalid
                            ,style: TextStyle(fontSize: 15,color: Colors.red),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text("I already have an account !"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Login',
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
      )
    );
  }
}
