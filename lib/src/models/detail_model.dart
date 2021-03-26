class DetailModel {
  final int id;
  final String service;
  final String username;
  final String encrypted_password;

  DetailModel({this.id, this.service, this.username, this.encrypted_password});

  DetailModel.fromDb(Map<String, dynamic> dbMap)
      : id = dbMap['id'],
        service = dbMap['service'],
        username = dbMap['username'],
        encrypted_password = dbMap['encrypted_password'];
}
