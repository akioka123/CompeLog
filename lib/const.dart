import 'dart:ui';

import 'package:flutter/material.dart';

import 'model/userModel.dart';

const Color AppBarThemaColor = Color(0xff7586c9);
const Color ButtonBackColor = Color(0xffc97586);
const Color ButtonTextColor = Color(0xffffffff);
const Color FieldTextColor = Color(0xffe5e5e5);
const Color ClearLog = Color(0xff59b9c6);
const Color NotClearLog = Color(0xffee827c);
const Color Yellow = Color(0xfff8b500);

const String DATETIME_FORMAT = "yyyy/MM/dd HH:mm:ss";
const String DATE_FORMAT = "yyyyMMdd";

const CLEAR = "クリア";
const NOT_CLEAR = "未クリア";
const BIGINNER = "ビギナー";
const MIDDLE = "ミドル";
const HIGHMIDDLE = "ハイミドル";
const OPEN = "オープン";

const START_LIST = {
  BIGINNER: [13],
  MIDDLE: [25],
  HIGHMIDDLE: [37],
  OPEN: [49]
};

///　級ごとの色わけリスト
const CLASS_COLOR_MAP = {
  "二段": Colors.black,
  "初段": Colors.black,
  "１級": Colors.black,
  "２級": Colors.black26,
  "３級": Colors.blueAccent,
  "４級": Colors.green,
  "５級": Colors.redAccent,
  "６級": Yellow,
  "７級": Colors.orangeAccent,
  "８級": Colors.pinkAccent,
};

///　級リスト
const CLASS_STR_LIST = [
  "二段",
  "初段",
  "１級",
  "２級",
  "３級",
  "４級",
  "５級",
  "６級",
  "７級",
  "８級",
];

const TextStyle font_size_20 = const TextStyle(fontSize: 20.0);

const InputDecoration appBarDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0)),
    contentPadding: EdgeInsets.only(left: 10.0),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ButtonBackColor, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ButtonBackColor, width: 2.0)),
    labelStyle: TextStyle(fontSize: 20.0, color: Colors.black),
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.black));

const InputDecoration bodyFormDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 10.0),
    labelStyle: TextStyle(fontSize: 20.0, color: Colors.black),
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.black));

// メニュー表示
List<Widget> showMyMenu(BuildContext context, UserModel _user) {
  List<Widget> menuList = [
    SizedBox(
      height: 70.0,
      child: DrawerHeader(
        child: Text(
          'Menu',
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    ),
    _makeBorderTile("Profile", () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/profile", arguments: _user);
    }),
    _makeBorderTile("All Log", () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/log", arguments: _user);
    })
  ];
  return menuList;
}

const Map NAVIGATE = {0: "/profile", 1: "/log"};

BottomNavigationBar makeBottomNavi(
    BuildContext context, int current, var args) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: AppBarThemaColor,
          label: 'Profile'),
      BottomNavigationBarItem(
          icon: Icon(Icons.photo_album),
          backgroundColor: AppBarThemaColor,
          label: 'All Log'),
    ],
    type: BottomNavigationBarType.shifting,
    currentIndex: current,
    onTap: (index) {
      if (current != index) {
        current = index;
        Navigator.pushReplacementNamed(context, NAVIGATE[index],
            arguments: args);
      } else {
        debugPrint("同じページがクリックされました。");
      }
    },
  );
}

BottomNavigationBar makeBottom(BuildContext context, int current) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: AppBarThemaColor,
          label: 'Profile'),
      BottomNavigationBarItem(
          icon: Icon(Icons.photo_album),
          backgroundColor: AppBarThemaColor,
          label: 'All Log'),
    ],
    type: BottomNavigationBarType.shifting,
    currentIndex: current,
    onTap: (index) {
      if (current != index) {
        current = index;
      } else {
        debugPrint("同じページがクリックされました。");
      }
    },
  );
}

Widget _makeBorderTile(String tileName, Function tapAct) {
  return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListTile(
        title: Text(
          tileName,
          style: TextStyle(fontSize: 20.0),
        ),
        onTap: tapAct,
      ));
}

const List<DropdownMenuItem<String>> SEX_LIST = [
  DropdownMenuItem(
      value: "男",
      child: Text(
        "男",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
  DropdownMenuItem(
      value: "女",
      child: Text(
        "女",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
  DropdownMenuItem(
      value: "秘密",
      child: Text(
        "秘密",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
];

const List<DropdownMenuItem<String>> CLASS_LIST = [
  DropdownMenuItem(
      value: "ビギナー",
      child: Text(
        "ビギナー",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
  DropdownMenuItem(
      value: "ミドル",
      child: Text(
        "ミドル",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
  DropdownMenuItem(
      value: "ハイミドル",
      child: Text(
        "ハイミドル",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
  DropdownMenuItem(
      value: "オープン",
      child: Text(
        "オープン",
        locale: Locale("ja"),
        style: TextStyle(fontSize: 20.0),
      )),
];

const Map<String, num> NEW_RESULT = {
  "二段": 0,
  "初段": 0,
  "１級": 0,
  "２級": 0,
  "３級": 0,
  "４級": 0,
  "５級": 0,
  "６級": 0,
  "７級": 0,
  "８級": 0,
};
