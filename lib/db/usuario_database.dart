import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ola_mundo_sqlite/db/app_database.dart';
import 'package:ola_mundo_sqlite/usuario/usuario.dart';
import 'package:sqflite/sqlite_api.dart';

class UsuarioDatabase {
  static final UsuarioDatabase _db =
      UsuarioDatabase._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  UsuarioDatabase._internal(this._appDatabase);

  static UsuarioDatabase get() {
    return _db;
  }

  Future<List<Usuario>> getUsuarios() async {
    var db = await _appDatabase.getDatabase();
    // var where = " WHERE ${Usuario.COLUNA_ID} != 1;";
    var resultado = await db.rawQuery('SELECT * FROM ${Usuario.TABELA}');

    List<Usuario> lista = List();
    for (Map<String, dynamic> item in resultado) {
      var usuario = Usuario.fromMap(item);
      lista.add(usuario);
    }
    return lista;
  }

  Future inserirOuAtualizar(Usuario usuario) async {
    if (usuario.id != null) {
      return atualizar(usuario);
    }
    String senhaMD5 = md5.convert(utf8.encode(usuario.senha)).toString();

    var db = await _appDatabase.getDatabase();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert('INSERT INTO '
          '${Usuario.TABELA}(${Usuario.COLUNA_ID},${Usuario.COLUNA_NOME},${Usuario.COLUNA_EMAIL},${Usuario.COLUNA_SENHA})'
          ' VALUES(${usuario.id},"${usuario.nome}", "${usuario.email}", "${senhaMD5}")');
    });
  }

  Future atualizar(Usuario usuario) async {
    String senhaMD5 = md5.convert(utf8.encode(usuario.senha)).toString();

    var db = await _appDatabase.getDatabase();
    return await db.transaction((Transaction txn) async {
      return await txn.rawInsert('UPDATE ${Usuario.TABELA} '
          'SET ${Usuario.COLUNA_EMAIL} = "${usuario.email}", '
          '${Usuario.COLUNA_NOME} = "${usuario.nome}", '
          '${Usuario.COLUNA_SENHA} = "${senhaMD5}" '
          'WHERE ${Usuario.COLUNA_ID} = ${usuario.id}');
    });
  }

  Future excluir(int id) async {
    var db = await _appDatabase.getDatabase();
    return await db.transaction((Transaction txn) async {
      return await txn.rawDelete(
          'DELETE FROM ${Usuario.TABELA} WHERE ${Usuario.COLUNA_ID} == $id;');
    });
  }

  /**
   * Checar Login
   */

  Future<bool> validar({String email, String senha}) async {
    String senhaMD5 = md5.convert(utf8.encode(senha)).toString();

    var db = await _appDatabase.getDatabase();
    var where = " where email = '$email' and senha = '${senhaMD5}'";
    var resultado = await db.rawQuery('SELECT * FROM ${Usuario.TABELA} $where');

    print(resultado);
    return resultado.length > 0 ? true : false;
  }
}
