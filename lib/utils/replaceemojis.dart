import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';

class ReplaceEmojis{
  static const regEx1 = '\\\\u([0-9a-fA-F]{4})';
  static const regEx2 = '$regEx1$regEx1';


  static String _regExEmojiUnicode(String text, String regEx) {
    final regexCheck = RegExp(regEx, caseSensitive: false);
    String newText = '';
    int _lastEndText = 0;
    int _lastEndNewText = 0;

    regexCheck.allMatches(text).forEach((match) {
      final start = match.start;
      final end = match.end;

      final String replacement = jsonDecode('"${match.group(0)}"');

      String startString;
      newText == ''
          ? startString = '${text.substring(0, start)}$replacement'
          : startString =
      '${newText.substring(0, _lastEndNewText)}${text.substring(_lastEndText, start)}$replacement';

      _lastEndNewText = startString.length;
      _lastEndText = end;

      newText =
      '$startString${text.substring(end)}';

    });

    if(newText == '') newText = text;

    return newText;
  }

  static String replaceEmoji(String text) {
    String newText = text;

    // Checking for 2-bytes and single bytes emojis
    if (newText.contains('\\u')) {
      newText = _regExEmojiUnicode(newText, regEx2);
    }
    if (newText.contains('\\u')){
      newText = _regExEmojiUnicode(newText, regEx1);
    }

    if(newText.toLowerCase().contains('#farmer_name#')) {
      newText = newText.replaceAll('#farmer_name#', Constant.englishyes?Constant.farmername +" ji":Constant.farmername+" ನವರೆ");
      newText = newText.replaceAll('#Farmer_name#', Constant.englishyes?Constant.farmername +" ji":Constant.farmername+" ನವರೆ");
    }

    if(newText.toLowerCase().contains('#label_name#')){
      newText = newText.replaceAll('#label_name#', Constant.englishyes?Constant.farmername:Constant.farmername);
    }

    return newText;
  }

}


