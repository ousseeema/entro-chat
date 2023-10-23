import 'package:flutter/material.dart';
import 'database/auth.dart';

import 'homepage.dart';
import 'loginpage.dart';

class ProfilDetails extends StatefulWidget {
  String email;
  String username;
  ProfilDetails({super.key, required this.email, required this.username});

  @override
  State<ProfilDetails> createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  authService authservice = authService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar et sont propr
      appBar: AppBar(
        title: const Text(
          'User Profil Details ',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      // liste QUI  sort de cote decran
      drawer: Drawer(
          child: ListView(
        //list scrolled with childreen text and liste tile and account icon
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          const Icon(
            //account icon qui replace la photo de profil
            Icons.account_circle,
            size: 150,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            // affiche le nom de lutilisateur dans le drawer
            widget.username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            // affiche le email de lutilisateur dans le drawer
            widget.email,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            //icons groups et text  si je click sur le buttom il ma affiche les groupe entre dans eux
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => const HomePage())));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              'Groups',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            //icon account with text ''profil'' to see details  of the user
            onTap: () {},
            selected:
                true, // selected ..lkif nhel list drower tbenli ena fi enhi widget b faci=on enha tlawen icon

            contentPadding: //padding
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
                Icons.manage_accounts), //le premier element de la list tile
            title: const Text(
              // text apres l icon
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
                  barrierDismissible:
                      false, // si lutilisateur click hors de box le box ne dismisss pas
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      //le dialog box qui return au showdialog with back ground color and shaped bordeer
                      backgroundColor: Colors.white,
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
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            //icon buttom de validation de demande de logout
                            onPressed: () async {
                              await authservice
                                  .logout(); //logout de le auth firebase et efface le shared preference

                              // ignore: use_build_context_synchronously
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
      // the end of the drower and the list view inside the drower
      body: Container(
        //container dans le taille de lecran
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              //icon account in the center of the widget
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              // row with text and email
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Fullname ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.username,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const Divider(
              //make line bettwen the two element
              thickness: 1.0,
              color: Colors.purple,
              height: 20,
            ),
            Row(
              // row with text and user name
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email ",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1.0,
              color: Colors.purple,
            ),
            Row(
              children: const [],
            )
          ],
        ),
      ),
    );
  }
}
