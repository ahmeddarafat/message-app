import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messageme_app/cubit/cubit.dart';
import 'package:messageme_app/cubit/states.dart';
import 'package:messageme_app/modules/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messageme_app/network/cache_helper.dart';
import 'package:messageme_app/shared/notifications.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);
  static String routeName = "Chat Screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
              backgroundColor:IsDark(),
              appBar: AppBar(
                backgroundColor: Colors.yellow[700],
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('images/vector.jpg'),
                    ),
                    const SizedBox(width: 10),
                    const Text('Friend'),
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
                  )
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

Color IsDark(){
  bool? dark = CacheHelper.getBool(key: 'isDark');
  if(dark!=null){
    return dark?Colors.black:Colors.white;
  }else{
    return Colors.white;
  }
}



