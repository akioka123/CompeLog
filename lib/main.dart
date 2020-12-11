import 'dart:async';

import 'package:CompeLog/page/myProfile.dart';
import 'package:CompeLog/page/personalResult.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'page/allLogPage.dart';
import 'page/loginPage.dart';
import 'page/signinPage.dart';
import 'page/homePage.dart';
import 'const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TLogApp());
}

class TLogApp extends StatelessWidget {
  final String titleText = 'Compe Log';

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale("en", "US"),
              const Locale("ja", "JP")
            ],
            title: titleText,
            theme: appBarTheme(context, false),
            darkTheme: appBarTheme(context, true),
            initialRoute: "/",
            // routes: {
            //   "/": (context) => HomePage(),
            //   "/signin": (context) => SigninPage(
            //         title: titleText,
            //       ),
            //   "/login": (context) => LoginPage(
            //         title: titleText,
            //       ),
            //   // "/show": (context) => ShowPage(),
            //   "/profile": (context) => MyProfile(),
            //   "/log": (context) => AllLog(),
            // },
            onGenerateRoute: (RouteSettings settings) {
              print("ルート作成");
              Map<String, WidgetBuilder> routes = {
                "/": (context) => HomePage(),
                "/signin": (context) => SigninPage(
                      title: titleText,
                    ),
                "/login": (context) => LoginPage(
                      title: titleText,
                    ),
                // "/show": (context) => ShowPage(),
                "/profile": (context) => MyProfile(settings.arguments),
                "/log": (context) => AllLog(settings.arguments),
                "/clear": (context) => PersonalResult(settings.arguments),
              };
              WidgetBuilder builder = routes[settings.name];
              return MaterialPageRoute(builder: (context) => builder(context));
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ThemeData appBarTheme(BuildContext context, bool _isdark) {
    final ThemeData theme = Theme.of(context);
    if (!_isdark) {
      return ThemeData.light().copyWith(
        primaryColor: Color(0xff7586c9),
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                height: 1.0),
            headline2: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            bodyText1:
                TextStyle(fontSize: 25.0, color: Colors.black, height: 1.2),
            bodyText2: TextStyle(fontSize: 25.0, color: Colors.white),
            subtitle1: TextStyle(fontSize: 15.0, color: Colors.black),
            subtitle2: TextStyle(fontSize: 15.0, color: Colors.white)),
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary, buttonColor: ButtonBackColor),
      );
    } else {
      return ThemeData.dark().copyWith(
          textTheme: TextTheme(bodyText1: TextStyle(fontSize: 20.0)),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(left: 5.0),
            border: OutlineInputBorder(),
          ),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary));
    }
  }
}
