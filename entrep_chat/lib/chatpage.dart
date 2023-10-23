import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'messages_tile.dart';
import 'database/databaseservice.dart';

import 'infogruppage.dart';

class ChatPage extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String userName;
  const ChatPage(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messagescontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getadminname();
  }

  getadminname() {
    DatabaseService().getchat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getgroupadmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return messages(
                        message: snapshot.data.docs[index]["message"],
                        sender: snapshot.data.docs[index]["sender"],
                        sentbyme: widget.userName ==
                            snapshot.data.docs[index]["sender"]);
                  })
              : Container();
        });
  }

  sendmessages() {
    if (messagescontroller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messagescontroller.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messagescontroller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.groupName.toUpperCase(),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
                onPressed: () {
                  // icon info  if i click it will take me to the  widget infogrouppage
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => InfoGroupPage(
                                groupId: widget.groupId,
                                groupName: widget.groupName,
                                adminName: admin,
                              ))));
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: Stack(
          children: <Widget>[
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: MediaQuery.of(context).size.width,
                color: Colors.purple,
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                    controller: messagescontroller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendmessages();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ));
  }
}
