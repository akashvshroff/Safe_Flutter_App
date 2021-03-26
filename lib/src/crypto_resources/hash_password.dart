import 'package:crypto/crypto.dart';
import 'dart:convert';

String getHash(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

bool verifyHash(String password, String hash) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return hash == digest.toString();
}

// void main() {
//   String password = 'scoop mute disown helper reporter duvet';
//   String hash = getHash(password);
//   print(hash);
//   print(verifyHash(password, hash));
// }
