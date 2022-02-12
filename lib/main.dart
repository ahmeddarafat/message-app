import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/cubit/bloc_observer.dart';
import 'package:messageme_app/cubit/cubit.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/modules/chat_screen.dart';
import 'package:messageme_app/modules/login_screen.dart';
import 'package:messageme_app/modules/register_screen.dart';
import 'package:messageme_app/network/cache_helper.dart';
import 'package:messageme_app/shared/notifications.dart';
import 'package:messageme_app/test_screen.dart';
import 'modules/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await NotiMessages.getToken();
  BlocOverrides.runZoned(
        () {
      // Use blocs...
          AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: TestScreen(),
      home:_auth.currentUser == null? WelcomeScreen():ChatScreen(),
      // initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName : (context)=>WelcomeScreen(),
        ChatScreen.routeName : (context)=>ChatScreen(),
        LoginScreen.routeName : (context)=>LoginScreen(),
        RegisterScreen.routeName : (context)=>RegisterScreen(),

      },
    );
  }
}
