import 'package:safe/src/models/detail_model.dart';

import 'safe_db_provider.dart';
import '../crypto_resources/dice_ware.dart';
import '../crypto_resources/encrypt_password.dart';
import '../crypto_resources/hash_password.dart';
import '../crypto_resources/random_password.dart';

class Repository {
  final safeDbProvider = SafeDbProvider();
  String _master;

  Future<String> getMasterHash() async {
    //returns master hash else null if not master
    return await safeDbProvider.fetchMasterHash();
  }

  Future<String> createMasterPassword() async {
    //creates new master password, adds hash to db and returns it
    _master = getDiceWarePassword(n: 3);
    String masterHash = getHash(_master);
    safeDbProvider.addMasterHash(masterHash);
    return _master;
  }

  Future<bool> checkMasterPassword(String masterInput) async {
    //verifies inputted master password against hash in db
    String masterHash = await safeDbProvider.fetchMasterHash();
    if (verifyHash(masterInput, masterHash)) {
      this._master = masterInput;
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateMasterPassword(String newPassword) async {
    //updates the master password stored in the db
    List<DetailModel> details = await fetchAllDetails();
    List<String> decryptedPasswords = details.map((detail) {
      return getDecryptedPassword(detail);
    }).toList();

    _master = newPassword;
    for (int i = 0; i < details.length; i++) {
      updateDetail(decryptedPasswords[i], details[i]);
    }
    String masterHash = getHash(_master);
    safeDbProvider.addMasterHash(masterHash);
  }

  Future<List<DetailModel>> fetchAllDetails() async {
    //fetch all the details from the db
    return await safeDbProvider.fetchAllDetails();
  }

  Future<DetailModel> fetchDetailById(int id) async {
    //fetch detail based on id
    return await safeDbProvider.fetchDetail(id);
  }

  Future<int> addDetail(String service, String username, String password) {
    //add a fresh detail to the db
    dynamic encryptedPassword =
        getEncryptedPassword(password, service, username);
    DetailModel detail = DetailModel(
        id: null,
        service: service,
        username: username,
        encryptedPassword: encryptedPassword);
    return safeDbProvider.addPassword(detail);
  }

  Future<int> updateDetail(String newPassword, DetailModel detail) {
    //update a detail in the db
    String encryptedPassword =
        getEncryptedPassword(newPassword, detail.service, detail.username);
    detail.encryptedPassword = encryptedPassword;
    return safeDbProvider.updatePassword(detail);
  }

  Future<int> deleteDetail(int detailId) {
    //delete a detail in the db
    return safeDbProvider.deletePassword(detailId);
  }

  String getDiceWarePassword({n: 5}) {
    //returns a diceware password of length n
    return diceWarePassword(n);
  }

  String getRandomPassword({length: 16}) {
    //random alphanum password
    return randomPassword(length);
  }

  String getEncryptedPassword(
      String password, String service, String username) {
    //get encrypted password using master and AES
    String key = this._master + service + username;
    if (key.length <= 32) {
      key += 'x' * 32;
    }
    key = key.substring(0, 32);
    return encryptPassword(password, key);
  }

  String getDecryptedPassword(DetailModel detail) {
    //get the original password from encrypted using master and AES
    String key = this._master + detail.service + detail.username;
    key = key.substring(0, 32);
    return decryptPassword(detail.encryptedPassword, key);
  }
}
