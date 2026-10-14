
import 'package:flutter/foundation.dart';

import '../locator.dart';
import '../services/usuario_repository.dart';

class RecuperacaoController extends ChangeNotifier {
  final UsuarioRepository _repository = getIt<UsuarioRepository>();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool validarEmail(String email) {
    return RegExp(
      r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
    ).hasMatch(email.trim());
  }

  Future<bool> recuperarSenha(String email) async {
    errorMessage = null;
    successMessage = null;

    if (email.trim().isEmpty) {
      errorMessage = 'Informe seu e-mail.';
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
      await Future.delayed(const Duration(milliseconds: 500));

      final usuario = _repository.buscarPorEmail(email);

      if (usuario == null) {
        errorMessage = 'Não existe uma conta cadastrada com esse e-mail.';
        return false;
      }

      // Demonstração: não envia e-mail de verdade.
      successMessage =
          'E-mail reconhecido! A recuperação está simulada nesta versão.';
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível solicitar a recuperação.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void limparMensagens() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
