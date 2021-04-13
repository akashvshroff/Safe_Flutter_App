import '../models/detail_model.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class Bloc {
  final Repository _repository = Repository();

  //StreamControllers

  //access master password
  final _masterPassword = PublishSubject<String>();
  //check if inputted password is master
  final _verifyMasterPassword = PublishSubject<bool>();
  //show all the details
  final _showDetails = PublishSubject<List<DetailModel>>();
  //pass an individual DetailModel
  final _showDetailFocus = PublishSubject<DetailModel>();
  //pass a generated password, either diceware or random
  final _generatePassword = PublishSubject<String>();
  //update master process status - true if complete
  final _masterUpdateStatus = PublishSubject<bool>();

  //getters to Stream
  Stream<String> get masterPasswordStream => _masterPassword.stream;
  Stream<bool> get verifyMasterStream => _verifyMasterPassword.stream;
  Stream<List<DetailModel>> get details => _showDetails.stream;
  Stream<DetailModel> get detailFocus => _showDetailFocus.stream;
  Stream<String> get generatePasswordStream => _generatePassword.stream;
  Stream<bool> get masterUpdateStatus => _masterUpdateStatus.stream;

  //getters to sink
  Function(DetailModel) get detailFocusSink => _showDetailFocus.sink.add;
  Function(String) get generatePasswordSink => _generatePassword.sink.add;
  Function(String) get masterPasswordSink => _masterPassword.sink.add;
  Function(bool) get masterUpdateSink => _masterUpdateStatus.sink.add;

  //Master Password functions

  void fetchMasterPassword() async {
    //add master password to master stream
    final masterPassword = await _repository.createMasterPassword();
    masterPasswordSink(masterPassword);
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

  String fetchExistingMasterPassword() {
    //fetch existing master password and add to stream
    return _repository.masterPassword;
  }

  Future<void> updateMasterPassword(String newPassword) async {
    //updates the master password and adds to the sink if the process is successful
    await _repository.updateMasterPassword(newPassword);
    masterUpdateSink(true);
  }

  //Crypto functions

  void fetchDiceWarePassword() {
    //returns a 5 word random password
    String password = _repository.getDiceWarePassword();
    generatePasswordSink(password);
  }

  void fetchRandomPassword() {
    //returns a random alphanumeric password
    String password = _repository.getRandomPassword();
    generatePasswordSink(password);
  }

  Future<String> fetchDecryptedPassword(DetailModel detail) async {
    //fetch decrypted password for a particular detail instance
    return _repository.getDecryptedPassword(detail);
  }

  //CRUD Operations with DB

  Future<void> fetchDetails() async {
    //fetch all the details and add to stream
    List<DetailModel> details = await _repository.fetchAllDetails();
    _showDetails.sink.add(details);
  }

  void fetchDetailById(int id) async {
    //fetch a detail using id and add to stream
    final DetailModel detail = await _repository.fetchDetailById(id);
    _showDetailFocus.sink.add(detail);
  }

  Future<int> addDetail(String service, String username, String password) {
    //add a detail to the db
    return _repository.addDetail(service, username, password);
  }

  Future<int> updateDetail(int id, String service, username, String password) {
    //update a detail with existing id
    DetailModel detail = DetailModel(
        id: id, service: service, username: username, encryptedPassword: '');
    return _repository.updateDetail(password, detail);
  }

  Future<int> deleteDetailById(int id) {
    //delete detail
    return _repository.deleteDetail(id);
  }

  void dispose() {
    //close all the StreamControllers
    _masterPassword.close();
    _verifyMasterPassword.close();
    _showDetails.close();
    _showDetailFocus.close();
    _generatePassword.close();
  }
}
