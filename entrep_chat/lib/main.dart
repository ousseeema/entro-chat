import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helper.dart';

import 'homepage.dart';
import 'loginpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  bool _isSignedIn = false;

  @override
  // lors de louverture de lapplication le initstate se relance toujours pour affiche la page que lon affiche
  void initState() {
    super.initState();

    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    // verification et initialization de la variable issignedin selon le resultat de class helper function qui verifi le  key existe ou non
    await HelperFunction.getUserLooggedInStatus().then(
      (value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //if the key existe in  shared preference
      //then affiche home page
      // if not affiche login page

      home: _isSignedIn ? const HomePage() : const LogInPage(),
    );
  }
}
