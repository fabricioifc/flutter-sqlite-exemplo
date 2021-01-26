import 'package:flutter/material.dart';
import 'package:ola_mundo_sqlite/usuario/usuario.dart';
import 'package:ola_mundo_sqlite/usuario/usuario_controller.dart';
import 'package:ola_mundo_sqlite/usuario/usuario_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usuario> lista = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    // List<Usuario> lista = await UsuarioDatabase.get().getUsuarios();

    // lista.forEach((element) {
    //   print(element.toMap());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
        ),
        body: _criarListaUsuarios());
  }

  FutureBuilder _criarListaUsuarios() {
    UsuarioController controller = UsuarioController(UsuarioRepository());

    return FutureBuilder(
      future: controller.listarTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Usuario item = snapshot.data[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text(item.nome),
                    subtitle: Text(item.email),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      print('clicou no item');
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}
