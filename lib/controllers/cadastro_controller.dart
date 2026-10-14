
import 'package:flutter/foundation.dart';

import '../models/usuario_model.dart';
import '../services/usuario_repository.dart';
import '../locator.dart';

class CadastroController extends ChangeNotifier {
  final UsuarioRepository _repository = getIt<UsuarioRepository>();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool validarEmail(String email) {
    return RegExp(
      r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
    ).hasMatch(email.trim());
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String confirmarSenha,
  }) async {
    errorMessage = null;
    successMessage = null;

    if (nome.trim().isEmpty ||
        email.trim().isEmpty ||
        telefone.trim().isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      errorMessage = 'Preencha todos os campos.';
      notifyListeners();
      return false;
    }

    if (nome.trim().length < 2) {
      errorMessage = 'O nome deve ter pelo menos 2 caracteres.';
      notifyListeners();
      return false;
    }

    if (!validarEmail(email)) {
      errorMessage = 'Informe um e-mail válido.';
      notifyListeners();
      return false;
    }

    if (senha.length < 6) {
      errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      notifyListeners();
      return false;
    }

    if (senha != confirmarSenha) {
      errorMessage = 'As senhas não são iguais.';
      notifyListeners();
      return false;
    }

    if (_repository.emailExiste(email)) {
      errorMessage = 'Este e-mail já está cadastrado.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final usuario = UsuarioModel(
        id: DateTime.now().microsecondsSinceEpoch,
        nome: nome.trim(),
        email: email.trim().toLowerCase(),
        telefone: telefone.trim(),
        senha: senha,
      );

      final cadastrado = _repository.adicionar(usuario);

      if (!cadastrado) {
        errorMessage = 'Este e-mail já está cadastrado.';
        return false;
      }

      successMessage = 'Conta criada com sucesso!';
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível criar sua conta.';
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
