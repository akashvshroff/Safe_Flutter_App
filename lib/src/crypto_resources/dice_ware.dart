import 'eff_wordlist.dart';
import 'dart:math';

String getDiceWarePassword(int length) {
  List<String> words = [];
  Random rnd = Random();
  for (int i = 0; i <= length; i++) {
    String word = '';
    for (int r = 0; r < 5; r++) {
      int roll = rnd.nextInt(6) + 1;
      word += roll.toString();
    }
    words.add(eff_wordlist[word]);
  }

  return words.join(' ');
}
