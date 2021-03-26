import 'dart:math';
import 'dart:convert';

String getRandomPassword(int length) {
  final Random _random = Random.secure();
  var values = List<int>.generate(32, (i) => _random.nextInt(256));
  return base64UrlEncode(values).substring(0, length);
}
