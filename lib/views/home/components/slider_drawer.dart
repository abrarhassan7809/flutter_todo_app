import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final List<IconData> icons = [
    CupertinoIcons.home, CupertinoIcons.person_fill,
    CupertinoIcons.settings, CupertinoIcons.info_circle_fill,
  ];

  final List<String> texts = [
    "Home", "Profile", "Settings", "Details"
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_24.png",
          ),),
          8.h,
          Text("Abrar Hassan", style: textTheme.displayMedium,),
          Text("Flutter Dev", style: textTheme.displaySmall,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {log("${texts[index]} Item Tab");},
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: Icon(icons[index], color: Colors.white, size: 30,),
                      title: Text(texts[index], style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
