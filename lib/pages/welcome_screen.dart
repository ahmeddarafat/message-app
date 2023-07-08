import 'package:flutter/material.dart';
import 'package:messageme_app/pages/login_screen.dart';
import 'package:messageme_app/pages/register_screen.dart';
import 'package:messageme_app/shared/components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static String routeName = "Welcome Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/vector.jpg',
                  height: 180,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.yellow[700],
                      ),
                    ),
                    Text(
                      ' Me',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                myButton(
                  title: "Login",
                  color: Colors.blue[800],
                  onPress: () {
                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                myButton(title: "Register", color: Colors.yellow[700],onPress: () {
                  Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
