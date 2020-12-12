import 'package:CompeLog/model/fireStoreService.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PersonalResult extends StatefulWidget {
  final List clears;
  PersonalResult(this.clears);

  @override
  _PersonalResultState createState() => _PersonalResultState();
}

class _PersonalResultState extends State<PersonalResult> {
  int _nowIndex = 0;
  FireStoreService _fireStoreService;

  void dispose() {
    super.dispose();
  }

  Future<List> _getUsers() async {
    List _users = [];
    for (int i = _nowIndex;
        i < widget.clears.length && i < _nowIndex + 10;
        i++) {
      if (widget.clears.length == 0) {
        return _users;
      }
      if (widget.clears[i].isNotEmpty) {
        _users.add(
            await _fireStoreService.userColRef.doc(widget.clears[i]).get());
      }
    }
    return _users;
  }

  String _clearListToString(Map clearList) {
    String resultStr = "";
    clearList.forEach((key, value) {
      if (key == "４級") {
        resultStr += "\n";
      }
      resultStr += key + ":" + value.toString() + "本  ";
    });
    return resultStr;
  }

  List<Card> _userCard(List userSnapshots, BuildContext context) {
    return userSnapshots.map((snapshot) {
      Map user = snapshot.data();
      return Card(
        child: ListTile(
          title: textToJap(user["name"],
              style: Theme.of(context).textTheme.bodyText1),
          subtitle: textToJap(_clearListToString(user["result"]),
              style: Theme.of(context).textTheme.subtitle1),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _fireStoreService = Provider.of<FireStoreService>(context);
    return Scaffold(
        appBar: AppBar(
          title: textToJap("クリアメンバー"),
        ),
        body: FutureBuilder<List>(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot<List> users) {
            if (users.hasError) {
              return Text(
                "問題が発生しました。",
                locale: Locale("ja"),
                style: Theme.of(context).textTheme.bodyText1,
              );
            }
            if (users.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (users.data == null || users.data.length == 0) {
              return Text(
                "誰もいません",
                locale: Locale("ja"),
                style: Theme.of(context).textTheme.bodyText1,
              );
            }

            return ListView(
              padding: const EdgeInsets.all(5.0),
              children: _userCard(users.data, context),
            );
          },
        ));
  }
}
