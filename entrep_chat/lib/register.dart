import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'database/auth.dart';
import 'widget/widget.dart';

import 'homepage.dart';
import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  String password = "";
  String email = "";
  String fullname = "";
  //creation dune instance de la class auth pour on peut accedere a la fonction creation user avec password and email
  authService authservice = authService();

  bool _isLoding = false;
  // fonction appelee lors de click sur le buttom signup

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoding = true;
      });
      await authservice
          .registeruserwithemailandpassword(fullname, email, password)
          .then((value) {
        if (value == true) {
          //saving the prefrences shared after creating account and loged in , besh mera jeya ki y7el tet3ed direct page home ken howa connecte
          HelperFunction.saveuserlogin(true);
          HelperFunction.saveusername(fullname);
          HelperFunction.saveuseremail(email);
          // APRES ENREGISTRE LE shared prefrences en envoyer lutilisateur au page home
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          //call the snackbar function in the widget.dart to create a snack bar with the error inside of it if an error detected
          showsnackbar(context, Colors.red, value);
          //if you want do not ceate a void showsnackbar but do this code instade
          /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value, style: const TextStyle(fontSize: 14)),
            duration: const Duration(seconds: 7),
            showCloseIcon: true,
            closeIconColor: Colors.lightBlue,
             ));*/
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
        // if isstate change true il va affiche une circule de chargement
        body: _isLoding
            ? const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : SingleChildScrollView(
                //to make only the child column scrolling
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                            'Sign Up  in now to see what they talk about!',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          //insertion de limage de login
                          Image.asset("images/signup.png"),

                          //insertion de champs de text full name
                          TextFormField(
                            // tout la decoration de la champs input
                            decoration: const InputDecoration(
                              label: Text(
                                'FullName',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                              // le icon de email fixed dans le debut de la champs de text
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),

                              // la decoration lorsqueil ya une erreur dans le chmps de text
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),

                              // la decoration lorsque en clik sur le champs de text
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),

                              // decration de champs de text lorsque on ne clik pas sur elle
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
                              ),
                            ),
                            //fonction on changed pour ennregistre le valeur de champs email
                            onChanged: ((value) {
                              //on change le state de le champs lors de lecriteur de l utilisateur
                              setState(() {
                                fullname = value;
                              });
                            }),
                            // verification de name
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 7) {
                                return null;
                              } else {
                                return " Invalide Full Name ";
                              }
                            },
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          //insertion dun chaps de text de email
                          TextFormField(
                            // tout la decoration de la champs input
                            decoration: const InputDecoration(
                              label: Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                              // le icon de email fixed dans le debut de la champs de text
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.purple,
                              ),

                              // la decoration lorsqueil ya une erreur dans le chmps de text
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),

                              // la decoration lorsque en clik sur le champs de text
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),

                              // decration de champs de text lorsque on ne clik pas sur elle
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
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
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
                              ),
                              // le icon de email fixed dans le debut de la champs de text
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.purple,
                              ),

                              // la decoration lorsqueil ya une erreur dans le chmps de text
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),

                              // la decoration lorsque en clik sur le champs de text
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),

                              // decration de champs de text lorsque on ne clik pas sur elle
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
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
                                register();
                              },
                              child: const Text('Sign Up'),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // add  span below the buttom
                          Text.rich(
                            // text rich  est ensemble de text en meme ligne  , n7oto TextSpan fi 3odh text
                            TextSpan(
                              text: "You already have an account!",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " Login now  ",
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
                                                  const LogInPage())));
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
