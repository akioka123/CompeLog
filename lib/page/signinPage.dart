import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  final String title;
  SigninPage({Key key, this.title});
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  ///ID
  String _userId;

  ///ログインユーザー
  UserModel _user = UserModel();

  FirebaseFirestore _db = FirebaseFirestore.instance;

  ///クラス選択　初期値
  String _chosenClass = "ミドル";

  ///性別選択　初期値
  String _chosenGender = "男";

  ///　認証確認
  bool _success = true;

  ///　パスワードの隠ぺい切り替え処理
  bool _isObscure = true;

  ///新規登録処理
  void _register(BuildContext context) async {
    try {
      ///FireAuth新規登録
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      ///FireAuth情報追加　更新形式
      await user.updateProfile(displayName: _nameController.text);

      ///ユーザー情報　アプリ内で引数として使いまわす
      _user.id = user.uid;
      _user.name = _nameController.text;
      _user.gender = _chosenGender;
      _user.className = _chosenClass;
      _user.result = NEW_RESULT;

      _db.collection("User").doc(user.uid).set({
        "name": _nameController.text,
        "gender": _chosenGender,
        "class": _chosenClass,
        "result": NEW_RESULT,
        "createAt": Timestamp.now(),
        "updateAt": Timestamp.now(),
      });
      if (user != null) {
        setState(() {
          if (_success) {
            _userId = user.uid;
          }
        });
      } else {
        _success = false;
      }
    } catch (e) {
      print(e);
    }
  }

  /// 各種入力欄　パッドセット
  /// hgt：高さ　wdh：幅
  Widget _fieldBox(Widget inBox, double hgt, double wdh) {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: SizedBox(
          height: hgt,
          width: wdh,
          child: inBox,
        ));
  }

  /// メールアドレス入力欄
  Widget _buildEmailInputField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'メールアドレスを入力してください';
          } else if (!value.contains('@') || !value.contains('.')) {
            return '正しいフォーマットを入力してください 例) xxxx@yyy.com';
          }
          return null;
        },
      ),
    );
  }

  /// 名前入力欄
  Widget _buildNameInputField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Account',
          counterStyle: TextStyle(),
          hintText: '10文字以内で入力してください。',
          border: OutlineInputBorder(),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'アカウント名を入力してください';
          } else if (value.length >= 10) {
            return 'アカウント名は10文字以内にしてください。';
          }
          return null;
        },
      ),
    );
  }

  /// パスワード入力欄
  Widget _buildPasswordInputField() {
    return Stack(
      children: <Widget>[
        Container(
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isObscure,
            controller: _passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: '6文字以上で入力してください。',
              border: OutlineInputBorder(),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'パスワードを入力してください';
              } else if (value.length < 6) {
                return '6文字以上で入力してください';
              }
              return null;
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            iconSize: 18.0,
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        )
      ],
    );
  }

  /// 性別選択欄
  Widget _buildGenderSelectField() {
    return Container(
      child: DropdownButton<String>(
          value: _chosenGender,
          items: SEX_LIST,
          hint: Text("選択"),
          onChanged: (String chosen) {
            setState(() {
              _chosenGender = chosen;
            });
          }),
    );
  }

  /// クラス選択欄
  Widget _buildClassSelectField() {
    return Container(
      child: DropdownButton<String>(
          value: _chosenClass,
          items: CLASS_LIST,
          hint: Text("選択"),
          onChanged: (String chosen) {
            setState(() {
              _chosenClass = chosen;
            });
          }),
    );
  }

  ///新規登録画面　画面表示
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス　入力欄
              _fieldBox(_buildEmailInputField(), 80.0, 250.0),

              // 名前　入力欄
              _fieldBox(_buildNameInputField(), 80.0, 250.0),

              // パスワード　入力欄
              _fieldBox(_buildPasswordInputField(), 80.0, 250.0),

              // 性別　入力欄
              _fieldBox(_buildGenderSelectField(), 40.0, 80.0),

              // クラス　入力欄
              _fieldBox(_buildClassSelectField(), 40.0, 130.0),

              // 新規登録ボタン
              RaisedButton(
                color: Colors.white,
                child: Text('新規ユーザー登録'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _register(context);
                    _db.terminate();
                    Navigator.pushReplacementNamed(context, '/profile',
                        arguments: _user);
                  }
                },
              ),

              // ログイン画面遷移
              RaisedButton(
                color: Colors.white,
                child: Text('ログインはこちら'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
