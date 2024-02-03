import 'package:flutter/material.dart';

class PersonListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function()? onTap;
  const PersonListTile(
      {super.key, required this.title, required this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    //print("app list tile ${title}");
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent, //Theme.of(context).colorScheme.primary,
            border: Border.all(
                width: 0.5,
                color: Theme.of(context).colorScheme.secondaryContainer),
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            subTitle,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
