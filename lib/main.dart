import 'package:flutter/material.dart';
import 'package:ola_mundo_sqlite/db/app_database.dart';
import 'package:ola_mundo_sqlite/db/usuario_database.dart';
import 'package:ola_mundo_sqlite/models/usuario.dart';
import 'package:sqflite/sqlite_api.dart';

import 'db/usuario_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // como pegar a conexão com o banco de dados
  // Database db = await AppDatabase.get().getDatabase();

  // singleton utilizado para trabalhar com a tabela de usuários
  List<Usuario> lista = await UsuarioDatabase.get().getUsuarios();

  // imprimindo todos os usuários cadastrados
  lista.forEach((element) {
    print(element.toMap());
  });

  // validando email e senha
  bool usuarioValido = await UsuarioDatabase.get()
      .validar(email: 'teste@teste.com', senha: 'teste');

  print(usuarioValido);

  // Excluindo o usuário 1
  int usuarioId = 5;
  int excluidoComSucesso = await UsuarioDatabase.get().excluir(usuarioId);
  print(excluidoComSucesso);

  // Inserindo outro usuário
  // try {
  //   int idUsuarioInserido =
  //       await UsuarioDatabase.get().inserirOuAtualizar(Usuario(
  //           // id: 6,
  //           email: 'professor@gmail.com',
  //           nome: 'Professor',
  //           senha: 'professor123'));
  //   print(idUsuarioInserido);
  // } on Exception catch (e) {
  //   print(e);
  // }

  // Executando o App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

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
    return FutureBuilder(
      future: UsuarioDatabase.get().getUsuarios(),
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
