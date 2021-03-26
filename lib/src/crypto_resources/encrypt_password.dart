import 'package:encrypt/encrypt.dart';

dynamic encryptPassword(String password, String keyString) {
  final key = Key.fromUtf8(keyString);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(password, iv: iv);
  return encrypted;
}

String decryptPassword(dynamic encrypted_password, String keyString) {
  final key = Key.fromUtf8(keyString);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt(encrypted_password, iv: iv);
  return decrypted;
}

// void main() {
//   String keyString =
//       'This is the entire situation here scoop mute disown helper reporter duvet';
//   keyString = keyString.substring(0, 32);
//   final encrypted_password = encryptPassword(
//     'This is the original password',
//     keyString,
//   );
//   print(decryptPassword(encrypted_password, keyString));

// }
