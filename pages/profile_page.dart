import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

import '../components/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> getCurrentUser(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    String userName = await authService.getCurrentUserName();
    return userName;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("P R O F I L E"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          //elevation: 0,
        ),
        drawer: const AppDrawer(),
        backgroundColor: Theme.of(context).colorScheme.background,
        //body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        //    future: getUserDetails(), builder: (context, snapshot) {}),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();

                return Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(user!['email']),
                    Text(user['uid'])
                  ],
                ));
              } else {
                return const Text("No data");
              }
            }));
  }
}
