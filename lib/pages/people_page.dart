import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/app_drawer.dart';
import '../components/person_tile.dart';
import '../pages/chat_page.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey[900],
        title: const Text("P E O P L E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: buildUserList(),
      /**** 
        body: Column(children: [
          Center(
            child: Text(
              "LOGGED IN AS: " + user.email!,
              style: TextStyle(fontSize: 20),
            ),
          )
        ]) 
        **/
    );
  }

  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //print("snapshot ${snapshot.data}");
        if ((snapshot.connectionState == ConnectionState.waiting) ||
            (snapshot.data == null)) {
          return const Text("Loading ...");
        } else {
          List l = snapshot.data!.docs.toList();
          //print("got list of size ${l.length}");
          return ListView(
            children: l.map<Widget>((doc) => buildUserListItem(doc)).toList(),
          );
        }
      },
    );
  }

  Widget buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //print("data ${data}");
    if (user.email != data['email']) {
      return PersonListTile(
        title: data['email'],
        subTitle: "",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverEmail: data['email'],
                        receiverUid: data['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
