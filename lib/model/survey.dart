import 'package:cloud_firestore/cloud_firestore.dart';

/***
 * Survey(
  title : String,
  isSingleChoice : bool,
  answerChoices : Map<String, List<Choice>?>,
  isMandatory : bool,
  errorText : String,
  answers : List<String>
)
 */
class Survey {
  final String name;
  final String title;
  final String senderId;
  final String senderEmail;
  final Timestamp timestamp;
  final List<Choice> questions;
  Map<String, Choice> answers;

  Survey(
      {required this.name,
      required this.title,
      required this.senderId,
      required this.senderEmail,
      required this.timestamp,
      required this.questions,
      required this.answers});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'timestamp': timestamp,
    };
  }
}

class Choice {
  final String cid;
  final String text;
  Choice({required this.cid, required this.text});
}
