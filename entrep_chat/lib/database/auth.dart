// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:entrep_chat/helper.dart';

import 'databaseservice.dart';

class authService {
//make a instance of fire base

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  //wa9et el click 3le buttom sign in ynadi el fonction hedhy besh tshouf est ce que 3enda compte wele lee
  Future LoginWithEmailAndPassord(String Email, String Password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: Email, password: Password))
          .user!; //connecte a une compte en fire base auth

      // ignore: unnecessary_null_comparison
      if (user != null) {
        //verification si le user est not null alors if ne faut
        // pas  enregistre le donnee dans la base de donne (firestore) car lutilisateur eiste deja

        return true;
      }
    } on FirebaseAuthException catch (e) {
      // ken feme erreur firebase auth exception tkharja
      return e.message;
    }
  }

  //register
  // if the user is on the app for the first time with no compte
  Future registeruserwithemailandpassword(
      String fullname, String Email, String Password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: Email, password: Password))
          .user!; //creation dune compte en fire base auth

      // ignore: unnecessary_null_comparison
      if (user != null) {
        //verification si le user est not null alors if faut enregistre le donnee dans la base de donne (firestore)
        //call our databaseservice
        DatabaseService(uid: user.uid).createUserData(fullname, Email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout

  Future logout() async {
    try {
      //in the logout yazemk tbadel el shared prefrences besh tnjm
      // tkhrjek ll page login ken ma taamlsh hekeke taamlk logout ema tkhalik fi home page
      await HelperFunction.saveuseremail("");
      await HelperFunction.saveusername("");
      await HelperFunction.saveuserlogin(false);
      await firebaseAuth.signOut(); // tkhrajek men compte mtak
    } catch (e) {
      return null;
    }
  }
}
