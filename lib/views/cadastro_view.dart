
import 'package:flutter/material.dart';

import '../locator.dart';
import '../controllers/cadastro_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final CadastroController controller = getIt<CadastroController>();
  final _formKey = GlobalKey<FormState>();

  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _senha = TextEditingController();
  final _confirmarSenha = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;

  static const azul = Color(0xFF1976D2);
  static const azulClaro = Color(0xFFEAF5FF);

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _senha.dispose();
    _confirmarSenha.dispose();
    super.dispose();
  }

  InputDecoration _decoracao(
    String label,
    IconData icone, {
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: azul),
      suffixIcon: sufixo,
      filled: true,
      fillColor: azulClaro.withValues(alpha: 0.45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6E9FA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: azul, width: 2),
      ),
    );
  }

  Future<void> _cadastrar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final sucesso = await controller.cadastrar(
      nome: _nome.text,
      email: _email.text,
      telefone: _telefone.text,
      senha: _senha.text,
      confirmarSenha: _confirmarSenha.text,
    );

    if (!mounted) return;

    final mensagem = sucesso
        ? 'Conta criada! Agora você pode entrar.'
        : controller.errorMessage ?? 'Não foi possível cadastrar.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green : Colors.redAccent,
      ),
    );

    if (sucesso) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.computer_rounded,
                          size: 64,
                          color: azul,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Faça parte do LojinTech!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: azul,
                          ),
                        ),
                        const SizedBox(height: 28),

                        TextFormField(
                          controller: _nome,
                          textCapitalization: TextCapitalization.words,
                          decoration: _decoracao(
                            'Nome completo',
                            Icons.person_outline,
                          ),
                          validator: (v) =>
                              v == null || v.trim().length < 2
                                  ? 'Informe seu nome.'
                                  : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _decoracao(
                            'E-mail',
                            Icons.email_outlined,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Informe seu e-mail.';
                            }
                            if (!controller.validarEmail(v)) {
                              return 'Digite um e-mail válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _telefone,
                          keyboardType: TextInputType.phone,
                          decoration: _decoracao(
                            'Número de telefone',
                            Icons.phone_outlined,
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Informe seu telefone.'
                                  : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _senha,
                          obscureText: !_mostrarSenha,
                          decoration: _decoracao(
                            'Senha (mínimo 6 caracteres)',
                            Icons.lock_outline,
                            sufixo: IconButton(
                              onPressed: () {
                                setState(() {
                                  _mostrarSenha = !_mostrarSenha;
                                });
                              },
                              icon: Icon(
                                _mostrarSenha
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.length < 6
                                  ? 'A senha deve ter pelo menos 6 caracteres.'
                                  : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _confirmarSenha,
                          obscureText: !_mostrarConfirmacao,
                          decoration: _decoracao(
                            'Confirmar senha',
                            Icons.lock_reset_outlined,
                            sufixo: IconButton(
                              onPressed: () {
                                setState(() {
                                  _mostrarConfirmacao =
                                      !_mostrarConfirmacao;
                                });
                              },
                              icon: Icon(
                                _mostrarConfirmacao
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Confirme sua senha.';
                            }
                            if (v != _senha.text) {
                              return 'As senhas não são iguais.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed:
                                controller.isLoading ? null : _cadastrar,
                            style: FilledButton.styleFrom(
                              backgroundColor: azul,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: controller.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Criar conta',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: controller.isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text(
                            'Já tenho uma conta • Voltar ao login',
                            style: TextStyle(color: azul),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
