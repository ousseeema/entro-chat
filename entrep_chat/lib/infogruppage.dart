import 'package:flutter/material.dart';
import 'database/databaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'homepage.dart';

class InfoGroupPage extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String adminName;
  InfoGroupPage(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.adminName});

  @override
  State<InfoGroupPage> createState() => _InfoGroupPageState();
}

class _InfoGroupPageState extends State<InfoGroupPage> {
  Stream? members;
  @override
  void initState() {
    getmembers();
    super.initState();
  }

  getmembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getgroupmembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getAdminName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return ListView.builder(
                    // liste view wiith a containers that hold the name of the person that join teh group with his id ù
                    itemCount: snapshot.data["members"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.purple,
                                child: Text(getAdminName(
                                        snapshot.data["members"][index])
                                    .substring(0, 1)
                                    .toUpperCase())),
                            title: Text(
                                getName(snapshot.data["members"][index]),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              getId(snapshot.data["members"][index]),
                            ),
                          ));
                    });
              } else {
                // if the group has no members it will show this :
                return const Center(child: Text("No Group Members"));
              }
            } else {
              return const Center(child: Text("No Group Members"));
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.grey));
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "INFO GROUP",
          style: TextStyle(letterSpacing: 2.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                //un widget qui return un dialog box lors de le click sur le buttom loug out
                barrierDismissible:
                    false, // si lutilisateur click hors de box le box ne dismisss pas
                context: context,
                builder: (context) {
                  return AlertDialog(
                    //le dialog box qui return au showdialog with back ground color and shaped bordeer
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    title: const Text(' exite '),
                    content: const Text(
                        'Are you sure you want to exite the group? '),
                    actions: [
                      // les action que on peut faire sur cette dialog box (yaani iconnuttom with function qui execute lors de le click)
                      IconButton(
                          //icon buttom de annulation de demande de logout
                          onPressed: () {
                            Navigator.pop(
                                context); // pop widget de dialog box de lecran et annuler le action de sortir
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )),
                      IconButton(
                          //icon buttom de validation de demande de logout
                          onPressed: () async {
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .togglinggroupjoin(widget.groupName,
                                    widget.groupId, getName(widget.adminName))
                                .whenComplete(() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const HomePage()))));
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          )),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          // this column will have the conatainer of grooup name and admin name and list of the members of the group
          children: [
            Container(
              // this is a fixed container with group name and admin name
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.purple,
                    child: Text(widget.groupName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Group : ${widget.groupName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(" Admin : ${getAdminName(widget.adminName)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ))
                    ],
                  )
                ],
              ),
            ), //end of the container of the admin name and group name
            // this function build to us a list view with  the nember of people in the chat
            memberList(),
          ],
        ),
      ),
    );
  }
}
