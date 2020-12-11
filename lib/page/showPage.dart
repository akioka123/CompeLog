import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowPage extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserModel _user;
  @override
  Widget build(BuildContext context) {
    int _current = 0;
    UserModel user = ModalRoute.of(context).settings.arguments;
    UserNotifer _userNotifer = UserNotifer(user);
    return ChangeNotifierProvider<UserNotifer>(
        create: (_) => _userNotifer,
        child: Scaffold(
            appBar: AppBar(),
            body: _makeBody(_current, context),
            bottomNavigationBar: makeBottom(context, _current)));
  }

  /// 選択ごとのページを切り替え
  Widget _makeBody(int _currentPage, BuildContext context) {
    if (_currentPage == 0) {
      return _showProfile(context);
    } else if (_currentPage == 1) {
      return _showAllLog(context);
    } else {
      return textToJap("存在しないページです");
    }
  }

  // 名前・性別・クラスの表示
  Widget _nameAgeGenderRow(BuildContext context) {
    UserModel user = Provider.of<UserNotifer>(context).user;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textToJap(user.name),
        textToJap(user.gender),
        textToJap(user.className)
      ],
    );
  }

  ///結果一覧の表示
  Widget _clearResult(BuildContext context) {
    /// _resultList作成
    UserModel user = Provider.of<UserNotifer>(context).user;
    List<Widget> resultList = [];
    user.result.forEach((key, value) {
      resultList.add(Row(children: [
        textToJap(key),
        textToJap(value.toString()),
      ]));
    });
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: resultList);
  }

  Widget _showProfile(BuildContext context) {
    _user = Provider.of<UserNotifer>(context).user;
    return FutureBuilder(
      future: _db.collection("User").doc(_user.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            "問題が発生しました。",
            locale: Locale("ja"),
            style: Theme.of(context).textTheme.bodyText2,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // ログデータの表示処理部分
        debugPrint("get snapshot data :" + snapshot.toString());
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _nameAgeGenderRow(context),
              _clearResult(context),
            ],
          ),
        );
      },
    );
  }

  /// 自分のクリアに追加　・級がいる
  /// clearにidを追加、または、削除
  /// クリア時と未クリア時の２パターン必要
  void _changeResult(BuildContext context, String id, List clearList) {
    _user = Provider.of<UserNotifer>(context).user;
    _db.collection("User").doc(_user.id).update({"result": _user.result});
    _db.collection("Log").doc(id).update({"clear": clearList});
  }

  List whereStart(BuildContext context) {
    UserModel user = Provider.of<UserNotifer>(context).user;
    List result;
    String className = user.className;
    result = START_LIST[className];
    return result;
  }

  Card _logCards(BuildContext context, DocumentSnapshot snapshot) {
    Map docData = snapshot.data();

    ///クリア・未クリア
    String isClear = NOT_CLEAR;
    UserModel user = Provider.of<UserNotifer>(context).user;

    ///クリアユーザーのidリスト
    List clearList = docData["clear"];
    if (clearList.contains(user.id)) {
      isClear = CLEAR;
    }
    return Card(
        child: ListTile(
      leading: textToJap(docData["number"]),
      title: textToJap(docData["class"] + docData["wall"]),
      subtitle: textToJap(isClear),
      trailing: IconButton(
          iconSize: 30.0,
          icon: Icon(
            Icons.check,
            color: Colors.blue,
          ),
          onPressed: () {
            if (isClear == CLEAR) {
              Provider.of<UserNotifer>(context)
                  .incrementResult(docData["class"]);
              clearList.add(user.id);
            } else {
              Provider.of<UserNotifer>(context)
                  .decrementResult(docData["class"]);
              clearList.remove(user.id);
            }
            _changeResult(context, snapshot.id, clearList);
          }),
    ));
  }

  ListView _listLog(BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
    return ListView(

        /// サイズ超過防止
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: query.data.docs.map((DocumentSnapshot docSnapshot) {
          return _logCards(context, docSnapshot);
        }).toList());
  }

  Widget _showAllLog(BuildContext context) {
    _user = Provider.of<UserNotifer>(context).user;
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection("Log")
            .orderBy("number")
            .startAt(whereStart(context))
            .limit(8)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          debugPrint(snapshot.connectionState.toString());
          if (snapshot.data == null) {
            return Text(
              "検索してください",
              locale: Locale("ja"),
              style: Theme.of(context).textTheme.bodyText2,
            );
          }
          if (snapshot.hasError) {
            return Text(
              "問題が発生しました。",
              locale: Locale("ja"),
              style: Theme.of(context).textTheme.bodyText2,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ログデータの表示処理部分
          debugPrint("get snapshot data :" + snapshot.toString());
          return _listLog(context, snapshot);
        },
      ),
    );
  }
}
