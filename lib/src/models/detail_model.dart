class DetailModel {
  final int id;
  final String service;
  final String username;
  String encryptedPassword;

  DetailModel({this.id, this.service, this.username, this.encryptedPassword});

  DetailModel.fromDb(Map<String, dynamic> dbMap)
      : id = dbMap['id'],
        service = dbMap['service'],
        username = dbMap['username'],
        encryptedPassword = dbMap['encryptedPassword'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'id': id,
      'service': service,
      'username': username,
      'encryptedPassword': encryptedPassword,
    };
  }
}
