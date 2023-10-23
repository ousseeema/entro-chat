// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'profildetails.dart';
import 'search.dart';
import 'database/auth.dart';
import 'database/databaseservice.dart';
import 'widget/groupTile.dart';
import 'widget/widget.dart';

import 'helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  authService authservice = authService();
  String username = "";
  String email = "";
  Stream? groups;
  bool _isloading = false;
  String? groupname;

  getuserdetails() async {
    await HelperFunction.getuseremailkeyfromsf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getusernamefromSf().then((value) {
      setState(() {
        username = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  void initState() {
    getuserdetails();

    super.initState();
  }

  nogroupWidget() {
    // if le personne qui utlise le application est n'a pas un groupe ou il quite tout les group qui il appartient
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        //column pour mettre les element foug baadhhom ema kol ma nkaber fi taille mta text kol ma column tzyd takber aala jnab
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                PopUpDialog(
                    context); // if lr utilisateur click sur le buttom + au centre de ecran
              },
              child:
                  const Icon(Icons.add_circle, size: 75, color: Colors.purple)),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "you've not joined any group yet!, Tap on the add icon to create or to search a group from top  in search buttom  ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// recuperation de nom et de id de group appartier de le uid de un seul  group enregistre dans lattribue groups dans user info
  getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  // the main role is to affiche the list of group that the user is goined in !
  groupList() {
    
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["groups"] != null) {
            if (snapshot.data["groups"].length != 0) {
              return ListView.builder(
                //fi home screen besh taamlelna liste scrolling apaartier de group eli dakhel fihom el utlilisateur
                itemCount: snapshot.data["groups"].length,
                // ignore: body_might_complete_normally_nullable
                itemBuilder: (context, index) {
                  //pour que en vas affiche les liste des groups de l
                  //a plus recente a l'ancien  on enversé le compteur
                  int inverseindex = snapshot.data["groups"].length - index - 1;
                  return GroupTile(
                    // thez kol group dakhel fih user w trajaahom fi form mtaa listtile w view builder besh yaffichihom fi liste scrolling
                    groupId: getId(snapshot.data["groups"][inverseindex]),
                    groupName: getName(snapshot.data["groups"][inverseindex]),
                    userName: snapshot.data['fullname'],
                  );
                },
              );
            } else {
              return nogroupWidget();
            }
          } else {
            return nogroupWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
      },
    );
  }

// function affiche une boite de dialog pour cree une group avec deux buttom valide ou annule
  PopUpDialog(BuildContext context) {
    showDialog(
        //dialog
        barrierColor: Colors.black38,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            // type de return de la widget showdialog est alert dialog
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Text("Create new group", // titre de alert box
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white)),
            backgroundColor:
                Colors.purple, //background color de la alert dialog
            content: Column(
              //un column dans le content de la dialog box , le column fih de champs de text b toul ken jyt nheb bahdha baadhhom njm n7ot row
              mainAxisSize: MainAxisSize.min,
              children: [
                //ken naati esm group w naaml valide besh yhezno yasn3li group si non besh  ykharejli circularprogress indicateur
                _isloading == true
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.purple),
                      )
                    : TextField(
                        // wa9et ena tapi fi textfield el variable group name gada zeda tetbadl fi nafes wa9et
                        onChanged: (value) {
                          setState(() {
                            groupname = value;
                          });
                        },
                        style: const TextStyle(color: Colors.black),

                        //textfield decoration
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.purpleAccent),
                          ),
                        ),
                      ),
              ],
            ),
            //action dans le dialog box dans notre cas annuler ou valide
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (groupname != "") {
                      setState(() {
                        _isloading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .creatingGroup(
                              username,
                              FirebaseAuth.instance.currentUser!
                                  .uid, //creating group and add it to the group info in the fire base
                              groupname!)
                          .whenComplete(() => _isloading = false);
                      Navigator.of(context).pop();
                      showsnackbar(context, Colors.green,
                          "Group created successfully."); // and affiche a snackbar if the group added successfully
                    } else {
                      showsnackbar(context, Colors.red,
                          "Cheeck your group name or your connection Please!"); // affiche un snack bar de erreur
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      // buttom craete inside of dialoge box
                      backgroundColor: Colors.purple[200]),
                  child: const Text('CREATE')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // buttom qui va pop la dialog bosx de la creation de la projet
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200]),
                  child: const Text('CANCEL')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //buttom search
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SearchPage())));
              },
              icon: const Icon(Icons.search)),
        ],
        // les propr de appbar
        elevation: 0,
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          "Groups",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      // list qui sortie de cote d'ecran
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          const Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            "User Name:  $username",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            "User Email :  $email",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            //icons groups si je click sur le buttom il ma affiche les groupe entre dans eux
            onTap: () {},
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              'Groups',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            //icon account <ith text inside the list tile  take us  to see details  of the user
            onTap: () {
              // function quii declanche lorsque on tap sur le tile list
              Navigator.pushReplacement(
                  //
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ProfilDetails(
                            email: email,
                            username: username,
                          ))));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

            leading: const Icon(Icons.manage_accounts),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            //logout icons si en click sur cette icons
            // la session ferme et renvoyer vers la page login
            onTap: () async {
              showDialog(
                  //un widget qui return un dialog box lors de le click sur le buttom loug out

                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      //le dialog box qui return au showdialog with back ground color and shaped bordeer

                      backgroundColor: const Color.fromARGB(255, 72, 60, 75),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      title: const Text(' Logout '),
                      content: const Text('Are you sure you want to logout '),
                      actions: [
                        // les action que on peut faire sur cette dialog box (yaani iconnuttom with function qui execute lors de le click)

                        IconButton(
                            //icon buttom de annulation de demande de logout
                            onPressed: () {
                              Navigator.pop(
                                  context); // pop widget de dialog box de lecran et annuler le action de sortir
                            },
                            icon: const Icon(
                              //icon cancel
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            //icon buttom de validation de demande de logout
                            onPressed: () async {
                              await authservice
                                  .logout(); //logout de le auth firebase et efface le shared preference

                              Navigator.pushAndRemoveUntil(
                                  // sortir de le compte et affiche le page de login
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const LogInPage())),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                      ],
                    );
                  });
            },

            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      )),

      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          PopUpDialog(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
