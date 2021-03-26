import 'safe_db_provider.dart';
import '../crypto_resources/dice_ware.dart';
import '../crypto_resources/encrypt_password.dart';
import '../crypto_resources/hash_password.dart';
import '../crypto_resources/random_password.dart';

class Repository {
  final safeDbProvider = SafeDbProvider();

  //check whether master password exists
  //if not, create one via diceware, hash it and store and return

  //check master password against stored hash

  //fetch all the details

  //convert encrypted password to password and vice-versa

  //CRUD operations on the details

}
