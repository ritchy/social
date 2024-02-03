import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/app_drawer.dart';
import '../components/list_tile.dart';
import '../components/my_textfield.dart';
import '../components/post_button.dart';
import '../database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController newPostController = TextEditingController();
  final FirestoreDatabase database = FirestoreDatabase();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      database.addPost(newPostController.text);
      newPostController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("W A L L"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
        ),
        drawer: const AppDrawer(),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(25),
              child: Row(children: [
                Expanded(
                  child: MyTextField(
                    hintText: "Say Something",
                    obscureText: false,
                    controller: newPostController,
                    onGo: postMessage,
                  ),
                ),
                PostButton(
                  onTap: postMessage,
                )
              ])),
          StreamBuilder(
              stream: database.getPostsStream(),
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
                          child: Text("No posts .. post something!")));
                }
              })
        ]));
  }
}
