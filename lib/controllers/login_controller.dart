
import 'package:flutter/foundation.dart';

import '../locator.dart';
import '../services/usuario_repository.dart';
import '../controllers/sessao_controller.dart';

class LoginController extends ChangeNotifier {
  
  final UsuarioRepository _repository = getIt<UsuarioRepository>();

  bool isLoading = false;
  String? errorMessage;
  
  bool validarEmail(String email) {
    return RegExp(
      r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
    ).hasMatch(email.trim());
  }

  Future<bool> entrar({
    required String email,
    required String senha,
  }) async {
    errorMessage = null;

    if (email.trim().isEmpty || senha.isEmpty) {
      errorMessage = 'Preencha o e-mail e a senha.';
      notifyListeners();
      return false;
    }

    if (!validarEmail(email)) {
      errorMessage = 'Informe um e-mail válido.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final usuario = _repository.buscarPorEmail(email);

      if (usuario != null && usuario.senha == senha) {
      getIt<SessaoController>().iniciarSessao(usuario);
      }

      if (usuario == null || usuario.senha != senha) {
        errorMessage = 'E-mail ou senha incorretos.';
        return false;
      }

      return true;
    } catch (_) {
      errorMessage = 'Não foi possível realizar o login.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void limparErro() {
    errorMessage = null;
    notifyListeners();
  }
}
