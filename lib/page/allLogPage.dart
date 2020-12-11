import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllLog extends StatefulWidget {
  final UserModel user;
  AllLog(this.user);
  @override
  _AllLogState createState() => _AllLogState();
}

class _AllLogState extends State<AllLog> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  UserModel _user;
  int _current = 1;
  Query _query;

  void initState() {
    super.initState();
    _user = widget.user;
    List result;
    String className = _user.className;
    result = START_LIST[className];
    _query = _db.collection("Log").orderBy("number").startAt(result).limit(6);
  }

  void dispose() {
    super.dispose();
  }

  /// 自分のクリアに追加　・級がいる
  /// clearにidを追加、または、削除
  /// クリア時と未クリア時の２パターン必要
  void _changeResult(String id, List clearList) {
    _db.collection("User").doc(_user.id).update({"result": _user.result});
    _db.collection("Log").doc(id).update({"clear": clearList});
    setState(() {});
  }

  void onCheckPressAction(String id, String isClear, Map docData) {
    if (isClear == NOT_CLEAR) {
      _user.result[docData["class"]] += 1;
      docData["clear"].add(_user.id);
    } else {
      _user.result[docData["class"]] -= 1;
      docData["clear"].remove(_user.id);
    }
    _changeResult(id, docData["clear"]);
  }

  /// ログの表示内容部分
  ///
  Card _logCards(DocumentSnapshot snapshot, String id) {
    Map docData = snapshot.data();

    ///クリア・未クリア
    String isClear = NOT_CLEAR;

    if (docData["clear"].contains(id)) {
      isClear = CLEAR;
    }
    if (isClear == CLEAR) {
      return Card(
          child: ListTile(
        tileColor: ClearLog,
        //導入部分　左端
        leading: textToJap(docData["number"].toString(),
            style: Theme.of(context).textTheme.headline2),
        //中央上部のメイン
        title: textToJap(
            docData["class"] +
                "    " +
                docData["wall"] +
                "    " +
                docData["clear"].length.toString() +
                "人",
            style: Theme.of(context).textTheme.bodyText2),
        //中央下部分のサブ
        subtitle: textToJap("         " + isClear,
            style: Theme.of(context).textTheme.subtitle2),
        //末尾　右端　ボタンなど　チェックボタンのみ
        trailing: IconButton(
            iconSize: 30.0,
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () => onCheckPressAction(snapshot.id, isClear, docData)),
      ));
    } else {
      return Card(
          child: ListTile(
        //導入部分　左端
        leading: textToJap(docData["number"].toString(),
            style: Theme.of(context).textTheme.headline1),
        //中央上部のメイン
        title: textToJap(
            docData["class"] +
                "    " +
                docData["wall"] +
                "    " +
                docData["clear"].length.toString() +
                "人",
            style: Theme.of(context).textTheme.bodyText1),
        //中央下部分のサブ
        subtitle: textToJap("         " + isClear,
            style: Theme.of(context).textTheme.subtitle1),
        //末尾　右端　ボタンなど　チェックボタンのみ
        trailing: IconButton(
            iconSize: 40.0,
            icon: Icon(
              Icons.add_circle_rounded,
              color: CLASS_COLOR_MAP[docData["class"]],
            ),
            onPressed: () => onCheckPressAction(snapshot.id, isClear, docData)),
      ));
    }
  }

  ListView _listLog(AsyncSnapshot<QuerySnapshot> query, UserModel _user) {
    return ListView(

        /// サイズ超過防止
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: query.data.docs.map((DocumentSnapshot docSnapshot) {
          return _logCards(docSnapshot, _user.id);
        }).toList());
  }

  void toAllLog(int index) {
    Navigator.pushNamed(context, "/log");
  }

  @override
  Widget build(BuildContext context) {
    List nextPageDoc;
    List beforePageDoc;

    return Scaffold(
      appBar: AppBar(title: textToJap("コンぺ　記録")),
      body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx < -10) {
              if (nextPageDoc[0] < 60) {
                setState(() {
                  _query = _db
                      .collection("Log")
                      .orderBy("number")
                      .startAfter(nextPageDoc)
                      .limit(6);
                });
              }
            } else if (details.velocity.pixelsPerSecond.dx > 10) {
              if (beforePageDoc[0] >= 0) {
                setState(() {
                  _query = _db
                      .collection("Log")
                      .orderBy("number")
                      .startAfter(beforePageDoc)
                      .limit(6);
                });
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FutureBuilder<QuerySnapshot>(
              future: _query.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                debugPrint("スナップショット取得　" + snapshot.connectionState.toString());
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

                nextPageDoc = [
                  snapshot.data.docs[snapshot.data.docs.length - 1]["number"]
                ];

                beforePageDoc = [snapshot.data.docs[0]["number"] - 7];

                // ログデータの表示処理部分
                debugPrint("get snapshot data :" +
                    snapshot.data.docs.length.toString());
                return _listLog(snapshot, _user);
              },
            ),
          )),
      bottomNavigationBar: makeBottomNavi(context, _current, _user.id),
    );
  }
}
