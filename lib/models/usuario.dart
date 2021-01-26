class Usuario {
  // Dados da Tabela (SQL)
  static final TABELA = 'usuarios';
  static final COLUNA_ID = 'id';
  static final COLUNA_EMAIL = 'email';
  static final COLUNA_NOME = 'nome';
  static final COLUNA_SENHA = 'senha';

  int id;
  String email;
  String nome;
  String senha;

  Usuario({this.email, this.nome, this.senha, this.id});

  Usuario copyWith({
    int id,
    String email,
    String nome,
    String senha,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Usuario(
      id: map['id'],
      email: map['email'],
      nome: map['nome'],
      senha: map['senha'],
    );
  }
}
