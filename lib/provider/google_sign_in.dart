import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_email_sign_in_flutter/firebase/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false; //set it initially to false
  }

  bool get isSigningIn => _isSigningIn; //getter and setter

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      final userData = FirebaseAuth.instance.currentUser.uid;
      await FirestoreService(uid: userData).updateUserData(
          user.displayName,
          user.email,
          DateTime
              .now()); //username.substring(0,username.indexOf(' ')).toLowerCase() --> for name to username
      isSigningIn = false;
    }
  }

  void logout() async {
    await googleSignIn.disconnect().whenComplete(() async {
      await FirebaseAuth.instance.signOut();
    });
    /*await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();*/
  }
}
