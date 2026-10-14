
import '../models/usuario_model.dart';

class UsuarioRepository {
  final List<UsuarioModel> _usuarios = [
    UsuarioModel(
      id: 1,
      nome: 'Usuário Teste',
      email: 'teste@lojintec.com',
      telefone: '(16) 99999-9999',
      senha: '123456',
    ),
  ];

  List<UsuarioModel> get usuarios =>
      List.unmodifiable(_usuarios);

  UsuarioModel? buscarPorEmail(String email) {
    final emailNormalizado = email.trim().toLowerCase();

    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() == emailNormalizado) {
        return usuario;
      }
    }

    return null;
  }

  bool emailExiste(String email) {
    return buscarPorEmail(email) != null;
  }

  bool adicionar(UsuarioModel usuario) {
    if (emailExiste(usuario.email)) {
      return false;
    }

    _usuarios.add(usuario);
    return true;
  }
}
