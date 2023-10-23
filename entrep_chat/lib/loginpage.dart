// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'database/auth.dart';
import 'database/databaseservice.dart';
import 'widget/widget.dart';

import 'helper.dart';
import 'homepage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoding = false;
  authService authservice = authService();
  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoding = true;
      });
      await authservice.LoginWithEmailAndPassord(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot
              snapshot = //besh yemshy yjib  fiha user data mn firebase store
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          HelperFunction.saveuserlogin(true);
          HelperFunction.saveusername(snapshot.docs[0]["fullname"]);
          HelperFunction.saveuseremail(email);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          showsnackbar(context, Colors.red, value);
          setState(() {
            _isLoding = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      //to make only the child column scrolling
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Groupie',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'Log in now to see what they talk about!',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),

                const SizedBox(
                  height: 15,
                ),

                //insertion de limage de login
                Image.asset("image/login.png"),

                //insertion dun chaps de text de email
                TextFormField(
                  // tout la decoration de la champs input
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    // le icon de email fixed dans le debut de la champs de text
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.purple,
                    ),

                    // la decoration lorsqueil ya une erreur dans le chmps de text
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),

                    // la decoration lorsque en clik sur le champs de text
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),

                    // decration de champs de text lorsque on ne clik pas sur elle
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                  ),
                  //fonction on changed pour ennregistre le valeur de champs email
                  onChanged: ((value) {
                    //on change le state de le champs lors de lecriteur de l utilisateur
                    setState(() {
                      email = value;
                    });
                  }),
                  // verification de email
                  validator: (value) {
                    return RegExp(
                                "^[_a-z0-9-]+(.[ _a-z0-9-]+)@[a-z0-9-]+(.[ a-z0-9-]+)(.[ a-z]{2,4})")
                            .hasMatch(value!)
                        ? null
                        : "verifie your Email";
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                // champs de text de password

                TextFormField(
                  obscureText: true, // pour affiche le mdp en ****
                  // tout la decoration de la champs input
                  decoration: const InputDecoration(
                    label: Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    // le icon de email fixed dans le debut de la champs de text
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.purple,
                    ),

                    // la decoration lorsqueil ya une erreur dans le chmps de text
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),

                    // la decoration lorsque en clik sur le champs de text
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),

                    // decration de champs de text lorsque on ne clik pas sur elle
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                  ),
                  // enregistre le conetnu de la champs password dans un variable password
                  onChanged: ((value) {
                    //on change le state de le champs lors de lecriteur de l utilisateur
                    setState(() {
                      password = value;
                    });
                  }),

                  //verifivation de password
                  validator: (value) {
                    if (value!.length < 7) {
                      return "Password must be more then 6 caractere";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //definir le style le buttom
                      backgroundColor: Colors.purple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          //le border  de la buttom
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // add  span below the buttom
                Text.rich(
                  // text rich  est ensemble de text en meme ligne  , n7oto TextSpan fi 3odh text
                  TextSpan(
                    text: "Don't have account ?",
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Register here!  ",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            decoration: TextDecoration
                                .underline), // to make a ligne under the text
                        //recognizer is to make the text link to send you to other pages if you
                        //click the text if faut import le libarier gesture
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const RegisterPage())));
                            //nextscreen(context,const  RegisterPage());
                          },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    ));
  }
}
