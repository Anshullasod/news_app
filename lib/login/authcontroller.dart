import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _firebaseauth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // WEB ARCHITECTURE: Use Firebase's native web popup
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // This triggers the secure browser popup
        UserCredential userCredential = await _firebaseauth.signInWithPopup(googleProvider);

        if (userCredential.user != null) {
          Get.offAllNamed('/home');
        }
      } else {
        // MOBILE ARCHITECTURE: Use GoogleSignIn package
        await _googleSignIn.initialize(
          serverClientId: "757598541562-ihungk6d4adshfq04j6aoj18bij5prej.apps.googleusercontent.com",
        );

        final GoogleSignInAccount? account = await _googleSignIn.authenticate();

        if (account == null) {
          print("User canceled the mobile login process");
          return;
        }

        final GoogleSignInAuthentication auth = await account.authentication;

        final AuthCredential cred = GoogleAuthProvider.credential(
          idToken: auth.idToken,
        );

        UserCredential userCredential = await _firebaseauth.signInWithCredential(cred);

        if (userCredential.user != null) {
          Get.offAllNamed('/home');
        }
      }
    }
    catch(e){
      print('Google SIgn-In failed: $e');
    }
  }
}