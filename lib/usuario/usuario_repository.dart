import 'package:ola_mundo_sqlite/db/usuario_database.dart';

class UsuarioRepository {
  final UsuarioDatabase db = UsuarioDatabase.get();

  Future listarTodos() async {
    return await db.getUsuarios();
  }
}
