import 'package:encrypt/encrypt.dart';

String encryptPassword(String password, String keyString) {
  final key = Key.fromUtf8(keyString); //key has to be length 32
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(password, iv: iv);
  return encrypted.base64;
}

String decryptPassword(String encryptedPassword, String keyString) {
  final encrypted = Encrypted.fromBase64(encryptedPassword);
  final key = Key.fromUtf8(keyString);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt(encrypted, iv: iv);
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
