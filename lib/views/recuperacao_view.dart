
import 'package:flutter/material.dart';

import '../locator.dart';
import '../controllers/recuperacao_controller.dart';

class RecuperacaoView extends StatefulWidget {
  const RecuperacaoView({super.key});

  @override
  State<RecuperacaoView> createState() => _RecuperacaoViewState();
}

class _RecuperacaoViewState extends State<RecuperacaoView> {
  final RecuperacaoController controller =
      getIt<RecuperacaoController>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static const azul = Color(0xFF1976D2);
  static const azulClaro = Color(0xFFEAF5FF);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _solicitarRecuperacao() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final sucesso = await controller.recuperarSenha(
      _emailController.text,
    );

    if (!mounted) return;

    final mensagem = sucesso
        ? controller.successMessage!
        : controller.errorMessage ?? 'Ocorreu um erro.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
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
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: azulClaro,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            size: 58,
                            color: azul,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Esqueceu sua senha?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: azul,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'Informe o e-mail utilizado no cadastro '
                          'para solicitar a recuperação da sua conta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'E-mail cadastrado',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: azul,
                            ),
                            filled: true,
                            fillColor: azulClaro.withValues(alpha: 0.45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFD6E9FA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: azul,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Informe seu e-mail.';
                            }

                            if (!controller.validarEmail(valor)) {
                              return 'Digite um e-mail válido.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: controller.isLoading
                                ? null
                                : _solicitarRecuperacao,
                            style: FilledButton.styleFrom(
                              backgroundColor: azul,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Solicitar recuperação',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextButton.icon(
                          onPressed: controller.isLoading
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Voltar para o login'),
                          style: TextButton.styleFrom(
                            foregroundColor: azul,
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
