import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatpage.dart';
import 'database/databaseservice.dart';
import 'widget/widget.dart';

import 'helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchcontroller = TextEditingController();
  bool isloding = false;
  bool userHasSearch = false;
  QuerySnapshot? searchsnapshot;
  String userName = "";
  User? user;
  bool isJoind = false;
  // function that check if user search for a group if the user has search for a group it will return a snapshot of the groups that have the same text given by the user
  initiateSearchMethode() async {
    if (searchcontroller.text.isNotEmpty) {
      setState(() {
        isloding = true;
      });
      await DatabaseService()
          .searchbyname(searchcontroller.text)
          .then((snapshot) {
        setState(() {
          searchsnapshot = snapshot;
          userHasSearch = true;
          isloding = false;
        });
      });
    }
  }

  // recupere user name from the shared preferences in helper page
  getuserNameandId() async {
    await HelperFunction.getusernamefromSf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  grouplist() {
    // besh taamli liste scrolling b list mtaa groups eli aamlt aalihom recherche
    return userHasSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchsnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchsnapshot!.docs[index]["groupId"],
                  searchsnapshot!.docs[index]["groupname"],
                  searchsnapshot!.docs[index]["admin"]);
            })
        : Container();
  }

  joinOrNot(
      // verifie le personne est en group ou non
      String userName,
      String groupId,
      String groupName,
      String admin) async {
    await DatabaseService(uid: user!.uid)
        .isuserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoind = value;
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

  // afiche un liste tile avec le formation nom group et joined or not
  groupTile(String userName, String groupId, String groupName, String admin) {
    joinOrNot(userName, groupId, groupName,
        admin); // verifie enta joined ll group ou non
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Admin : ${getName(admin)}"),
        trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid)
                .togglinggroupjoin(groupName, groupId, userName);
            if (isJoind) {
              // selon letat joined or  not en va affiche le buttom join a la fin de la list tile
              setState(() {
                isJoind = !isJoind;
              });
              // ignore: use_build_context_synchronously
              showsnackbar(
                  context, Colors.green, "Successfully joined the group !");
              Future.delayed(const Duration(seconds: 2), () {
                // future delayed besh naatel chway gbal ma nabaatha ll page chat
                Navigator.push(
                    // ken howa aaml ma kensh joined w aaml join besh nheza ll chat page
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ChatPage(
                            groupName: groupName,
                            groupId: groupId,
                            userName: userName))));
              });
            } else {
              setState(() {
                // sinon ken besh yokhrej nfaskhola kol shy mn grp w nkharjoula snackbar
                isJoind = !isJoind;
              });
              // ignore: use_build_context_synchronously
              showsnackbar(context, Colors.red,
                  "Left the group $groupName Successfully");
            }
          },
          child: isJoind// ken howa deja fi group naffichila joined bahdha esm el group eli lawej aalih sinon nafichilla join 
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text("joined",
                      style: TextStyle(color: Colors.white)),
                )
              : Container(//sinon besh ysyr hedha 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child:
                      const Text("join", style: TextStyle(color: Colors.white)),
                ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getuserNameandId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("SEARCH",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Container(
            //el text field w icon kol 7atithom fi container tlemhom kolbel row b kol chy
            color: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              // roww ll text field w icon buttom
              children: [
                Expanded(
                  // expanded besh taille kol presq yemshy ll container eli fiha text field w chway ll search icon fi lekher
                  child: TextField(
                    controller: searchcontroller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search for group.....",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  //container hatit fi wasetha icon search
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                    // buttom recherche dans la page search
                    onPressed: () {
                      initiateSearchMethode();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //ken aaml search tkharejla les groups eli aandhom nfes el esm eli lawej alih
          isloding
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : grouplist(), // pour affiche liste des group cherché
        ],
      ),
    );
  }
}
