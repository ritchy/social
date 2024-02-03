import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  //post a message
  Future<void> addPost(String message) {
    return posts.add({
      'email': currentUser!.email,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPostsStream() {
    final postStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp')
        .snapshots();
    return postStream;
  }

  // read posts from database
}
