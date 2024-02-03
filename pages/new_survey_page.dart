import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/survey_service.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class NewSurveyPage extends StatefulWidget {
  const NewSurveyPage({super.key});
  @override
  State<NewSurveyPage> createState() => _NewSurveyPageState();
}

class _NewSurveyPageState extends State<NewSurveyPage> {
  final TextEditingController newPostController = TextEditingController();
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final newChoiceController = TextEditingController();
  List<Widget> choiceWidgets = [];
  bool showNewSurvey = false;
  Map<String, String> choices = {};

  final SurveyService surveyService = SurveyService();

  void postSurvey() {
    if (newPostController.text.isNotEmpty) {
      //surveyService.postSurvey(survey);
      newPostController.clear();
    }
  }

  void addChoice() {
    //print("add choice ...");
    if (newChoiceController.text.isNotEmpty) {
      String choiceId = (choices.length + 1).toString();
      choices[choiceId] = newChoiceController.text;
      //print(choices);
      newChoiceController.clear();
      buildWidgetList();
    }
  }

  void buildWidgetList() {
    //print("buildlist.. from choices ${choices}");
    choiceWidgets.clear();
    List<Widget> temp = [];
    temp.add(const SizedBox(height: 25));
    String surveyTitle = "Title: 'Select a restaurant'";
    if (titleController.text.isNotEmpty) {
      surveyTitle = titleController.text;
    }
    temp.add(getSurveyTitle(surveyTitle));
    choices.forEach((k, v) => temp.add(getSurveyTile(v)));
    temp.add(const SizedBox(height: 15));
    temp.add(getSurveyTileEntry("Add Choice 'Bob's Cafe'"));
    temp.add(const SizedBox(height: 25));
    temp.add(
      Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: MyButton(
            text: "Post Survey",
            onTap: createNewSurvey,
          )),
    );
    setState(() {
      choiceWidgets = temp;
    });
    //choiceWidgets.clear();
  }

  void createNewSurvey() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  //void addSurveyTile() {
  //  print("adding new tile");
  //choiceWidgets.add(getSurveyTile("blah restaurante"));
  // }
  void addExistingChoices() {
    //print("getchoices ${choices.length}");
    //List<Widget> c = [];
    choices.forEach((k, v) => choiceWidgets.add(getSurveyTile(v)));
  }

  @override
  Widget build(BuildContext context) {
    buildWidgetList();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("N E W   S U R V E Y"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
        ),
        body: newSurveyWidget());
  }

  Widget newSurveyWidget() {
    return SafeArea(child: Center(child: ListView(children: choiceWidgets)));
  }

  List<Widget> getSurveyTiles() {
    return [
      MyTextField(
        controller: nameController,
        hintText: 'Name \'Pick Restuarant\'',
        obscureText: false,
      ),
      const SizedBox(height: 25),
      // email textfield
      MyTextField(
        controller: titleController,
        hintText: 'Title (Pick restaurant for tonight)',
        obscureText: false,
        onGo: () => {},
      )
    ];
  }

  Widget getSurveyTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: Container(
        child: MyTextField(
          controller: titleController,
          hintText: title,
          obscureText: false,
          onGo: () => {},
        ),
      ),
    );
  }

/**
 * decoration: BoxDecoration(
            color: Colors.transparent, //Theme.of(context).colorScheme.primary,
            border: Border.all(
                width: 0.5,
                color: Theme.of(context).colorScheme.secondaryContainer),
            borderRadius: BorderRadius.circular(12))
 */
  Widget getSurveyTileEntry(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Container(
        child: MyTextField(
          controller: newChoiceController,
          hintText: title,
          obscureText: false,
          onGo: addChoice,
        ),
      ),
    );
  }

  Widget getSurveyTile(String title) {
    //print('getSurveyTile for ${title}');
    return Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color:
                  Colors.transparent, //Theme.of(context).colorScheme.primary,
              border: Border.all(
                  width: .5,
                  color: Theme.of(context).colorScheme.secondaryContainer),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              )),
        ));
  }

  Widget buildMessageInput(TextEditingController newChoiceController) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(children: [
          Expanded(
              child: MyTextField(
                  onGo: () {},
                  controller: newChoiceController,
                  hintText: "Post Survey",
                  obscureText: false)),
          IconButton(
            onPressed: postSurvey,
            icon: const Icon(Icons.arrow_upward, size: 40),
          )
        ]));
  }
}
