import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function()? onTap;
  const AppListTile(
      {super.key, required this.title, required this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    //print("app list tile ${title}");
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
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
