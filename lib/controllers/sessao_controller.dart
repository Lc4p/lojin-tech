
import 'package:flutter/foundation.dart';
import '../models/usuario_model.dart';

class SessaoController extends ChangeNotifier {
  UsuarioModel? _usuarioAtual;

  UsuarioModel? get usuarioAtual => _usuarioAtual;

  bool get autenticado => _usuarioAtual != null;

  void iniciarSessao(UsuarioModel usuario) {
    _usuarioAtual = usuario;
    notifyListeners();
  }

  void encerrarSessao() {
    _usuarioAtual = null;
    notifyListeners();
  }
}
