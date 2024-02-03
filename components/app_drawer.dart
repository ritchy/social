import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        title: const Text("H O M E"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/home');
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        title: const Text("P R O F I L E"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile');
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        leading: Icon(
                          Icons.group,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        title: const Text("P E O P L E"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/people');
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: ListTile(
                        leading: Icon(
                          Icons.poll,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        title: const Text("S U R V E Y S"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/surveys');
                        },
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text("L O G O U T"),
                    onTap: () {
                      Navigator.pop(context);
                      signUserOut(context);
                      Navigator.pushNamed(context, '/login_or_register');
                    },
                  )),
            ]));
  }

  // sign user out method
  void signUserOut(BuildContext context) {
    //print("signing out ..");
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
    //FirebaseAuth.instance.signOut();
  }
}
