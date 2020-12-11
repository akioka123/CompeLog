import 'package:flutter/material.dart';

import 'const.dart';

///テキスト日本語化関数
///余白付きか余白なしかを選択可能
///styleも後付け可能
Widget textToJap(String word,
    {bool isPadding = true, TextStyle style = font_size_20}) {
  if (isPadding) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          word,
          style: style,
          locale: Locale("ja"),
        ));
  } else {
    return Text(
      word,
      style: style,
      locale: Locale("ja"),
    );
  }
}
