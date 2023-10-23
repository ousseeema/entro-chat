import 'package:flutter/material.dart';

import '../chatpage.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;

  const GroupTile(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    // create a liste tile fi wasta circle avatar w esm el group eli baathta
    // b construct eli fi page home w ki netki 3le kol list group thezni ll chat mtaaha
    return GestureDetector(
      onTap: () {
        // when i click the list tile it send me to the group chat with the full info of group and user and id group
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ChatPage(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName,
                    ))));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            // leading fih circle avatar w fi wasetha awel 7aref mn groupname
            backgroundColor: Colors.purple,
            radius: 30,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(widget.groupName.toUpperCase(), // title mtaa list tile
              style: const TextStyle(
                  fontWeight: FontWeight.bold, letterSpacing: 3.0)),
          subtitle: Text(
            //subtitle de listtile
            'Join the conversation as ${widget.userName}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
