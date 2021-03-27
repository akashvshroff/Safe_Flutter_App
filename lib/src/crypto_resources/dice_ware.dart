import 'eff_wordlist.dart';
import 'dart:math';

String diceWarePassword(int length) {
  List<String> words = [];
  Random rnd = Random.secure();
  for (int i = 0; i < length; i++) {
    String word = '';
    for (int r = 0; r < 5; r++) {
      int roll = rnd.nextInt(6) + 1;
      word += roll.toString();
    }
    words.add(effWordlist[word]);
  }

  return words.join(' ');
}
