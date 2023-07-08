import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messageme_app/cubit/cubit.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/pages/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messageme_app/network/cache_helper.dart';
import 'package:http/http.dart'as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String routeName = "Chat Screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final fbm =FirebaseMessaging.instance;
  String? token;
  String? friendToken;

  var messageController = TextEditingController();

  String? messageText;
  User? signInUser;

  // void getMessages() async {
  //   final messages = await _fireStore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  //
  // void getMessagesStream() async {
  //   await for (var snapshots in _fireStore.collection('messages').snapshots()) {
  //     for (var snapshot in snapshots.docs) {
  //       print(snapshot.data());
  //     }
  //   }
  // }

  void getCurrentUser() {
    try {
      if (_auth.currentUser != null) {
        signInUser = _auth.currentUser;
      }
    } catch (e) {
      print('the error in getCurrentUser : $e');
    }
  }
  void getOnMessaging(){
    FirebaseMessaging.onMessage.listen((event) {
      print("===========message sended ===========");
      print(event.data.toString());
    });
  }
  void getToken() {
    fbm.getToken().then((token) {
      print('=====================token==================');
      print(token);
      this.token = token;
      print('===========================================');
      // here i want to check if this device token is stored in cloud firestore so don't store it again
      //                  and if it isn't , store it
        _fireStore.collection('token').where('sender',isEqualTo:signInUser!.email)
            .get()
            .then((value) {
              // here if the first time to email  for storing token
                if (value.docs.length != 1) {
                  _fireStore.collection('token').add({
                    'sender': signInUser!.email,
                    'token': token,
                  });
                  // if the email already stored token
                }else if(value.docs.length == 1){
                  // if the email already stored token but its token changed by opening email form another device
                  if(value.docs[0].data()['token'] != token){
                    // delete the old and add the new
                    _fireStore.collection('token').doc(value.docs[0].id).delete();
                    _fireStore.collection('token').add({
                      'sender': signInUser!.email,
                      'token': token,
                    });
                  }
                }
            });
    });
  }
  Future<void> getFriendToken() async {
    final tokens = await _fireStore.collection('token').get();
    for (var token in tokens.docs) {
      // here we need to handle the the sender token
      if(token.data()['sender']=='ahmed1@gmail.com'){
        friendToken = token.data()['token'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getOnMessaging();
    getCurrentUser();
    getFriendToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>AppCubit(),
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},
          builder: (context,state){
            var cubit = AppCubit.get(context);
            return Scaffold(
              backgroundColor:isDark(),
              appBar: AppBar(
                backgroundColor: Colors.yellow[700],
                title: Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    const Text('Message Me'),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                    cubit.light();
                    },
                    icon: Icon(Icons.brightness_4_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
                    },
                    icon: const Icon(Icons.exit_to_app_outlined),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                            stream: _fireStore.collection('messages').orderBy('time').snapshots(),
                            builder: (context, snapshot) {
                              List<MessageLine> messagesWidget = [];
                              if (!snapshot.hasData) {
                                print('no message found');
                                print('${snapshot.data}');
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var messages = snapshot.data!.docs.reversed;
                              for (var message in messages) {
                                final messageText = message.get('text');
                                final messageSender = message.get('sender');
                                final currentUser = signInUser!.email;
                                final messageWidget = MessageLine(
                                  text: messageText,
                                  sender: messageSender,
                                  isMe: messageSender == currentUser,
                                );
                                messagesWidget.add(messageWidget);
                              }
                              return ListView(
                                reverse: true,
                                children: messagesWidget,
                              );
                            },
                          ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: messageController,
                              onChanged: (value) {
                                messageText = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Write your message here...',
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue[800]!),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue[800]!),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: FittedBox(
                            child: FloatingActionButton(
                              backgroundColor: Colors.blue[800],
                              onPressed: () {
                                messageController.clear();
                                _fireStore.collection('messages').add({
                                  'text': messageText,
                                  'sender': signInUser!.email,
                                  'time': FieldValue.serverTimestamp(),
                                });
                                sendMessage(signInUser!.email, messageText, friendToken);
                              },
                              child: const Icon(Icons.send),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),

    );
  }
}

class MessageLine extends StatelessWidget {
  final String? text;
  final String? sender;
  final bool isMe;

  const MessageLine({this.text, this.sender, required this.isMe, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(color: Colors.yellow[700]),
          ),
          SizedBox(
            height: 4,
          ),
          Material(
            color: isMe ? Colors.blue[800] : Colors.white,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color isDark(){
  bool? dark = CacheHelper.getBool(key: 'isDark');
  if(dark!=null){
    return dark?Colors.black:Colors.white;
  }else{
    return Colors.white;
  }
}

// send notification with rest api
Future<void> sendMessage(String? title,String? body,String? token)async {
  var serverToken = 'AAAAks2aZ9Q:APA91bFxeHX4WuQZl9lC3xYqkTYLcnb7Ojr0mb7IQADs-KuJelGwsWwJGq62uurQWz1drzEESyKe1e1rQmDSrTD4cDcMnEMDa55d5VKbs2CCCk7bCom14x5hPQ1spl1MZF3RfkXysHQ5';
  await await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '87',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );
}
