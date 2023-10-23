import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
//reference to our collection if she existe else create une collection avec le nom de user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
// references to our group collection
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
//creating  the user data when he create an account

  Future createUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilpic": "",
      "uid": uid,
    });
  }

  // reccupere data de user pour tester si le email donnee dans la login
  //page est existe ou non dans la base de donne
  // yyanni trajaali el doc eli fih email eli aadyt lors de lappel de la fionction
  Future gettingUserData(email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //  it will return snapshot of the the user details
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future creatingGroup(String username, String id, String groupname) async {
    // cette fonction est appellee lors de la click sur le buttom  de create dans le box de dialoge avec un nom valide
    DocumentReference groupDocumentReference = await groupCollection.add({
      //rference a nootre collection "group" pour ajoute un document qui a comme attrubie group name et id de currene user user name
      "groupname": groupname,
      "grouIcon": "",
      "admin": "${id}_$username",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    //updating thee members in collection group  pour ajoute le group et le idgroup  apres la creation de la document
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${id}_$username"]),
      "groupId": groupDocumentReference.id,
    });
    // updating user collection baaed ma kamlt 7atit esm el group w id w members fo document nemshy ll user collection  attrubie grroup nzyd uid de groupe fiha
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupname"]),
    });
  }

  //getting group admin
  Future getgroupadmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  //  get group members
  getgroupmembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search for the group
  // WA9ET NDKHEL ESM GROUP  fi recherche yemshy ll collection group w yrajaali group eli aandhom el esm heka
  searchbyname(String groupName) async {
    return groupCollection.where("groupname", isEqualTo: groupName).get();
  }

  // function will retrun if the user is jouined the group already or not
  Future<bool> isuserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userdocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocumentReference.get();
    List<dynamic> groups = await documentSnapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

// toggling the group join/exit
// ki nedi ll function hedhy besh tna7ini mn group wele tdakhelni ki netki aala jouin
  Future togglinggroupjoin(
      String groupName, String groupId, String userName) async {
    DocumentReference userdocumentreference = userCollection.doc(uid);
    DocumentReference groupdocumentreference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userdocumentreference.get();
    List<dynamic> groups = await documentSnapshot["groups"];
    // if user has our groups -> then remove them or also other part re join

    if (groups.contains("${groupId}_$groupName")) {
      await userdocumentreference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });

      await groupdocumentreference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userdocumentreference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });

      await groupdocumentreference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // getting the chats from a named group
  getchat(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // send messsagenand and creating collection message and updating data
  sendMessage(String groupId, Map<String, dynamic> chatMessagedata) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessagedata);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessagedata["message"],
      "recentMessageSender": chatMessagedata["sender"],
      "recentMessageTime": chatMessagedata["time"].toString()
    });
  }
}
