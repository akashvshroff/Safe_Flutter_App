import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import '../models/detail_model.dart';

class SafeDbProvider {
  Database db;
  var readyCompleter = Completer();
  Future get ready => readyCompleter.future;

  SafeDbProvider() {
    init().then((_) {
      readyCompleter.complete();
    });
  }

  Future init() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'passwords_safe_2.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute('''
          CREATE TABLE Details
            (
              id INTEGER PRIMARY KEY, 
              service TEXT,
              username TEXT, 
              encryptedPassword TEXT
            )
          ''');
        newDb.execute('''
          CREATE TABLE Master
            (
              id INTEGER,
              hash TEXT
            )
        ''');
        newDb.execute('INSERT INTO Master (id, hash) values (1, NULL)');
      },
    );
  }

  Future<String> fetchMasterHash() async {
    await ready;
    final maps = await db
        .query("Master", columns: null, where: 'id = ?', whereArgs: [1]);

    if (maps[0]['hash'] != null) {
      return maps[0]['hash'];
    } else {
      return null; //first time using app
    }
  }

  Future<int> addMasterHash(String hash) async {
    Map<String, dynamic> masterMap = {'id': 1, 'hash': hash};
    return db.update('Master', masterMap, where: 'id = ?', whereArgs: [1]);
  }

  Future<List<DetailModel>> fetchAllDetails() async {
    await ready;
    final maps = await db.query("Details", columns: null);
    final List<DetailModel> details = [];
    for (Map<String, dynamic> dbMap in maps) {
      details.add(DetailModel.fromDb(dbMap));
    }
    return details;
  }

  Future<DetailModel> fetchDetail(int id) async {
    await ready;
    final maps = await db
        .query('Details', columns: null, where: 'id = ?', whereArgs: [id]);
    final DetailModel detail = DetailModel.fromDb(maps[0]);
    return detail;
  }

  Future<int> addPassword(DetailModel detail) async {
    await ready;
    return db.insert(
      'Details',
      detail.toMapForDb(),
    );
  }

  Future<int> updatePassword(DetailModel detail) async {
    await ready;
    return db.update(
      'Details',
      detail.toMapForDb(),
      where: 'id = ?',
      whereArgs: [detail.id],
    );
  }

  Future<int> deletePassword(int id) async {
    await ready;
    return db.delete(
      'Details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
