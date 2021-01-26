import 'package:ola_mundo_sqlite/usuario/usuario.dart';
import 'package:ola_mundo_sqlite/usuario/usuario_repository.dart';

class UsuarioController {
  final UsuarioRepository _repository;

  UsuarioController(this._repository);

  Future<List<Usuario>> listarTodos() async {
    return await _repository.listarTodos();
  }
}
