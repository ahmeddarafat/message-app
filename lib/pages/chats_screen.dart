import 'package:flutter/material.dart';
import 'package:messageme_app/shared/constants.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List friends = [];
  List taps = ['Camera','Chats','Status','Calls'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Container(
            color: Constants.blueColor,
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (_,index)=>BuildTap(index: index,),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ChatItem();
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState!.showBottomSheet((context) {
            return SizedBox(
              height: 120,
              width: double.infinity,
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text('Message Me'),
      backgroundColor: Constants.blueColor,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
      ],
    );
  }
}

class BuildTap extends StatefulWidget {

   BuildTap({Key? key, this.index =1}) : super(key: key);

   int index ;

  @override
  State<BuildTap> createState() => _BuildTapState();
}

class _BuildTapState extends State<BuildTap> {
   int selected = 1;

   List taps = ['Camera','Chats','Status','Calls'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                setState(() {
                  selected = widget.index;
                });
                print("selected: $selected\n index : ${widget.index}");
              },
                child: Center(
                  child: Text(
                      taps[widget.index],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                      ),
                  ),
                )
            ),
          ),
          Container(
            width: double.infinity,
            height: 4,
            color: selected == widget.index?  Colors.white:Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'friend name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' time',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Text(
                      'last message',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
