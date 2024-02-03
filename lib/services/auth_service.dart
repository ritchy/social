import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      await ensureDocumentInStore(userCredential, email);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // show error to user
      }
      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
      }

      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    //initiate interactive sign in process
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //obtain auth credentials
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //perform sign in
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await ensureDocumentInStore(userCredential, googleUser.email);
    return userCredential;
  }

  ensureDocumentInStore(UserCredential userCredential, email) async {
    //ensure there's a doc in our store for this user
    fireStore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    }, SetOptions(merge: true));
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    // try creating the user
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //ensure there's a doc in our store for this user
      await ensureDocumentInStore(userCredential, email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      if (e.code == 'user-not-found') {
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {}
      throw Exception(e.code);
    }
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<String> getCurrentUserName() async {
    User? user = getCurrentUser();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return user!.displayName.toString();
  }

  // sign out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
