
import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  static const azul = Color(0xFF1976D2);
  static const azulClaro = Color(0xFFEAF5FF);

  // Substitua pelos dados reais da equipe e da disciplina.
  static const integrantes = [
    'Lívia Campanholo',
    'Guilherme Selani',
  ];

  static const disciplina = 'PPDM - Programação Para Dispositivos Móveis';
  static const instituicao = 'Fatec Ribeirão Preto';
  static const professor = 'Professor Rodrigo Plotze';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text('Sobre o LojinTech'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFEAF5FF),
                          Color(0xFFD6E9FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.computer_rounded,
                          color: azul,
                          size: 76,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'LojinTech',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: azul,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sua coleção, seu universo!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF42647D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SecaoSobre(
                    icone: Icons.lightbulb_outline,
                    titulo: 'Objetivo do aplicativo',
                    conteudo:
                        'O LojinTech é um aplicativo de comércio eletrônico '
                        'desenvolvido para reunir produtos colecionáveis '
                        'em um só lugar. A proposta é permitir que os '
                        'usuários explorem cards, bonecos, miniaturas e '
                        'acessórios, pesquisem produtos e organizem suas '
                        'compras de maneira simples e intuitiva.',
                  ),

                  _SecaoSobre(
                    icone: Icons.people_outline,
                    titulo: 'Equipe de desenvolvimento',
                    conteudo: integrantes
                        .map((nome) => '• $nome')
                        .join('\n'),
                  ),

                  _SecaoSobre(
                    icone: Icons.school_outlined,
                    titulo: 'Informações acadêmicas',
                    conteudo:
                        'Disciplina: $disciplina\n'
                        'Instituição: $instituicao\n'
                        'Professor(a): $professor',
                  ),

                  _SecaoSobre(
                    icone: Icons.code_rounded,
                    titulo: 'Tecnologias utilizadas',
                    conteudo:
                        'Flutter SDK\n'
                        'Linguagem Dart\n'
                        'Arquitetura Model–View–Controller (MVC)\n'
                        'GetIt para injeção de dependências\n'
                        'ChangeNotifier para gerenciamento de estado',
                  ),

                  _SecaoSobre(
                    icone: Icons.info_outline,
                    titulo: 'Versão do aplicativo',
                    conteudo:
                        'Versão 1.0.0\n'
                        'Projeto acadêmico desenvolvido para fins '
                        'de aprendizado.',
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'LojinTech © 2026',
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
        ),
      ),
    );
  }
}

class _SecaoSobre extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String conteudo;

  const _SecaoSobre({
    required this.icone,
    required this.titulo,
    required this.conteudo,
  });

  static const azul = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE1EFFB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: azul, size: 25),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: azul,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              conteudo,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF455A64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
