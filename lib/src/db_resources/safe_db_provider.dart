import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';

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
              password TEXT
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
}
