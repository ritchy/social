import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_drawer.dart';
import 'package:flutter_application_1/components/list_tile.dart';
import 'package:flutter_application_1/pages/new_survey_page.dart';
import 'package:flutter_application_1/services/survey_service.dart';

import '../components/new_survey_button.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});
  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController newPostController = TextEditingController();

  final SurveyService surveyService = SurveyService();

  void postSurvey() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("S U R V E Y S"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
        ),
        drawer: const AppDrawer(),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          NewSurveyButton(
              onTap: () {
                print("creating new survey...");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewSurveyPage()));
              },
              text: "New Survey"),
          const SizedBox(
            height: 30,
          ),
          getBody()
          //newSurveyWidget(),
        ]));
  }

  Widget getBody() {
    //print("get body");
    return showExistingSurveys();
  }

  Widget showExistingSurveys() {
    return StreamBuilder(
        stream: surveyService.getSurveys(),
        builder: (context, snapshot) {
          //show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // get all posts
          final posts = snapshot.data!.docs;
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          } else if (snapshot.hasData) {
            //print("posts count ${posts.length}");
            return Expanded(
              child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String email = post['email'];
                    String message = post['message'];
                    Timestamp timestamp = post['timestamp'];
                    //print("getting tile ${message}");
                    return AppListTile(title: message, subTitle: email);
                  }),
            );
          } else {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No surveys .. create one!")));
          }
        });
  }
}
