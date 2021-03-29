import '../models/detail_model.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class Bloc {
  final Repository _repository = Repository();

  final _masterPassword = PublishSubject<String>();
  final _verifyMasterPassword = PublishSubject<bool>();
  final _showDetails = PublishSubject<List<DetailModel>>();

  //getters to Stream
  Stream<String> get masterPasswordStream => _masterPassword.stream;
  Stream<bool> get verifyMasterStream => _verifyMasterPassword.stream;
  Stream<List<DetailModel>> get details => _showDetails.stream;

  void fetchMasterPassword() async {
    //add master password to master stream
    final masterPassword = await _repository.createMasterPassword();
    _masterPassword.sink.add(masterPassword);
  }

  Future<String> getMasterPasswordHash() async {
    //get master password hash if any
    return await _repository.getMasterHash();
  }

  void checkMasterPassword(String masterInput) async {
    //checks whether the input password is correct
    bool result = await _repository.checkMasterPassword(masterInput);
    if (result) {
      _verifyMasterPassword.sink.add(true);
    } else {
      _verifyMasterPassword.sink.addError('Wrong password');
    }
  }

  void fetchDetails() async {
    List<DetailModel> details = await _repository.fetchAllDetails();
    _showDetails.sink.add(details);
  }

  //stream for all the details and fn to add items to stream

  //stream to add detail to the db?

  //CRUD operations?
  Future<int> addDetail(String service, String username, String password) {
    return _repository.addDetail(service, username, password);
  }

  void dispose() {
    _masterPassword.close();
    _verifyMasterPassword.close();
  }
}
