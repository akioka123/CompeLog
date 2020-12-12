import 'package:CompeLog/const.dart';
import 'package:CompeLog/model/userModel.dart';
import 'package:CompeLog/textUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key key, this.title});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMsg = "";
  String userId;
  UserModel _user = UserModel();
  bool _isLogin = false;
  bool _isObscure = true;

  //ログイン
  void _login(BuildContext context) async {
    try {
      final UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      if (result.user != null) {
        setState(() {
          _isLogin = true;
          _user.id = result.user.uid;
          _db.collection("User").doc(_user.id).get().then((userProfile) {
            Map user = userProfile.data();
            _user.name = user["name"];
            _user.gender = user["gender"];
            _user.className = user["class"];
            _user.result = user["result"];
          });
          Navigator.pushReplacementNamed(context, '/profile',
              arguments: _user.id);
        });
      } else {
        setState(() {
          _errorMsg = "メールアドレスかパスワードが間違っています。";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _errorMsg = "メールアドレスかパスワードが間違っています。";
      });
    }
  }

  Widget _fieldBox(Widget inBox, double hgt, double wdh) {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: SizedBox(
          height: hgt,
          width: wdh,
          child: inBox,
        ));
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _isLogin
              ? const CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _fieldBox(_buildEmailInputField(), 80.0, 250.0),
                      _fieldBox(_buildPasswordInputField(), 80.0, 250.0),
                      textToJap(_errorMsg,
                          style: Theme.of(context).textTheme.subtitle1),
                      RaisedButton(
                        color: Colors.white,
                        child: Text('ログイン'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _login(context);
                          }
                        },
                      ),
                    ],
                  ),
                )),
    );
  }
}
