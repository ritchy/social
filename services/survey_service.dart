import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/survey.dart';

class SurveyService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> postSurvey(Survey survey) async {
    //get current user info
    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    await firestore
        .collection('surveys')
        .doc(currentUserId)
        .collection('surveys')
        .add(survey.toMap());
  }

  Stream<QuerySnapshot> getSurveys() {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    return firestore
        .collection('surveys')
        .doc(currentUserId)
        .collection('surveys')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
