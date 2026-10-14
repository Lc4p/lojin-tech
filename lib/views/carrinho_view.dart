
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../locator.dart';
import 'checkout_view.dart';

class CarrinhoView extends StatelessWidget {
  const CarrinhoView({super.key});

  static const azul = Color(0xFF1976D2);

  String moeda(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    final controller = getIt<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text('Meu carrinho'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final itens = controller.itensCarrinho;

          if (itens.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 72,
                      color: Color(0xFF90CAF9),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Seu carrinho está vazio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Adicione produtos para continuar.'),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: itens.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    final produto = item.produto;

                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF5FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                produto.emoji,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    produto.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(moeda(produto.preco)),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'Diminuir quantidade',
                                        onPressed: () => controller
                                            .removerDoCarrinho(produto.id),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: azul,
                                        ),
                                      ),
                                      Text('${item.quantidade}'),
                                      IconButton(
                                        tooltip: 'Aumentar quantidade',
                                        onPressed: () => controller
                                            .adicionarAoCarrinho(produto.id),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: azul,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Excluir produto',
                              onPressed: () =>
                                  controller.excluirDoCarrinho(produto.id),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFD6E9FA)),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            moeda(controller.totalCarrinho),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: azul,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutView(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: azul,
                          ),
                          child: const Text('Continuar para checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
