import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ola_mundo_sqlite/models/usuario.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDatabase {
  // Padrão Singleton
  static final AppDatabase _instancia = AppDatabase._internal();

  // Construtor privado
  factory AppDatabase() => _instancia;
  AppDatabase._internal();

  // Objeto do SqfLite
  Database _database;

  // get instancia
  static AppDatabase get() {
    return _instancia;
  }

  // identificar quando a base de dados já foi inicializada
  bool databaseInicializada = false;

  Future<Database> getDatabase() async {
    if (!databaseInicializada) await _criarBaseDeDados();
    return _database;
  }

  Future _criarBaseDeDados() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ola_mundo_db.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await _criarTabelaUsuario(db);
      // await _criarTabelaXXXXX(db);
      // await _criarTabelaXXXXX(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${Usuario.TABELA}");
      // await db.execute("DROP TABLE ${Model.tabela}");
      // await db.execute("DROP TABLE ${Model.tabela}");
      // await db.execute("DROP TABLE ${Model.tabela}");
      await _criarTabelaUsuario(db);
      // await _criarTabelaXXXXX(db);
      // await _criarTabelaXXXXX(db);
    });
    databaseInicializada = true;
  }

  Future _criarTabelaUsuario(Database db) {
    String senhaMD5 = md5.convert(utf8.encode('teste')).toString();

    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${Usuario.TABELA} ("
          "${Usuario.COLUNA_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Usuario.COLUNA_EMAIL} TEXT not null unique,"
          "${Usuario.COLUNA_NOME} TEXT,"
          "${Usuario.COLUNA_SENHA} TEXT);");
      print('Tabela ${Usuario.TABELA} criada com sucesso!');

      txn.rawInsert('INSERT INTO '
          '${Usuario.TABELA}(${Usuario.COLUNA_ID},${Usuario.COLUNA_EMAIL},${Usuario.COLUNA_NOME},${Usuario.COLUNA_SENHA})'
          ' VALUES(1, "teste@teste.com", "Usuário Teste", "${senhaMD5}");');
      print('Usuário teste inserido com sucesso!');
    });
  }
}
