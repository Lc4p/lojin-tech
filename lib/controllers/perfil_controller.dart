
import 'package:flutter/foundation.dart';
import '../models/usuario_model.dart';

class PerfilController extends ChangeNotifier {
  final UsuarioModel usuario;

  late String nomeEditado;
  String? erroNome;
  bool salvando = false;
  bool salvo = false;

  PerfilController({required this.usuario}) {
    nomeEditado = usuario.nome;
  }

  void alterarNome(String valor) {
    nomeEditado = valor;
    erroNome = null;
    salvo = false;
    notifyListeners();
  }

  bool salvar() {
    final nome = nomeEditado.trim();

    if (nome.isEmpty) {
      erroNome = 'O nome é obrigatório.';
      notifyListeners();
      return false;
    }

    if (nome.length < 3) {
      erroNome = 'Digite um nome com pelo menos 3 caracteres.';
      notifyListeners();
      return false;
    }

    salvando = true;
    notifyListeners();

    usuario.nome = nome;

    salvando = false;
    salvo = true;
    erroNome = null;

    notifyListeners();
    return true;
  }

  void cancelarEdicao() {
    nomeEditado = usuario.nome;
    erroNome = null;
    salvo = false;
    notifyListeners();
  }
}
