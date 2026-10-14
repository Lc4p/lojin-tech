
import 'package:flutter/material.dart';
import '../controllers/perfil_controller.dart';
import '../controllers/sessao_controller.dart';
import '../locator.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  static const azul = Color(0xFF1976D2);
  static const azulClaro = Color(0xFFEAF5FF);

  PerfilController? controller;
  final TextEditingController nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final usuario = getIt<SessaoController>().usuarioAtual;

    if (usuario != null) {
      controller = getIt<PerfilController>(param1: usuario);
      nomeController.text = usuario.nome;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perfil = controller;

    if (perfil == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meu perfil'),
          backgroundColor: Colors.white,
          foregroundColor: azul,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Nenhum usuário autenticado. Faça login para acessar seu perfil.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text('Meu perfil'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: perfil,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 28,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: azulClaro,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.computer_rounded,
                                size: 48,
                                color: azul,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              perfil.usuario.nome,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF174A7E),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Sua conta LojinTech',
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Informações da conta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF174A7E),
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextField(
                        controller: nomeController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: perfil.alterarNome,
                        decoration: InputDecoration(
                          labelText: 'Nome do usuário',
                          hintText: 'Digite seu nome',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: azul,
                          ),
                          errorText: perfil.erroNome,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
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
                      ),

                      const SizedBox(height: 18),

                      TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: perfil.usuario.email,
                        ),
                        decoration: InputDecoration(
                          labelText: 'E-mail cadastrado',
                          helperText: 'O e-mail não pode ser alterado aqui.',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: azul,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF0F4F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (perfil.salvo)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Perfil atualizado com sucesso!',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: perfil.salvando
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();

                                  final sucesso = perfil.salvar();

                                  if (sucesso) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Nome atualizado com sucesso!',
                                          ),
                                        ),
                                      );
                                  }
                                },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Salvar alterações'),
                          style: FilledButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        onPressed: () {
                          perfil.cancelarEdicao();
                          nomeController.text = perfil.nomeEditado;
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.undo),
                        label: const Text('Cancelar edição'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: azul,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: azul),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'LojinTech • Sua coleção, seu universo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
