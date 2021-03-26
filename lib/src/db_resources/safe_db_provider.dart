import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
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
    String path = join(databasePath, 'safe.db');
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
              encryptedPassword BLOB
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

  Future<DetailModel> fetchDetail(String service, String username) async {
    await ready;
    final maps = await db.query("Details",
        columns: null,
        where: 'service = ? AND username = ?',
        whereArgs: [service, username]);

    if (maps.length > 0) {
      return DetailModel.fromDb(maps.first);
    } else {
      return null;
    }
  }

  Future<int> addPassword(DetailModel item) async {
    await ready;
    return db.insert(
      'Details',
      item.toMapForDb(),
    );
  }

  Future<int> updatePassword(DetailModel item) async {
    await ready;
    return db.update(
      'Details',
      item.toMapForDb(),
      where: 'id = ?',
      whereArgs: [item.id],
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
