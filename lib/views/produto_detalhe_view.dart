
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../locator.dart';
import '../models/produto_model.dart';

class ProdutoDetalheView extends StatelessWidget {
  final ProdutoModel produto;

  const ProdutoDetalheView({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    final controller = getIt<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do produto'),
        backgroundColor: Colors.lightBlue.shade100,
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              final favorito = controller.ehFavorito(produto.id);

              return IconButton(
                tooltip: favorito
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: favorito ? Colors.red : Colors.black87,
                ),
                onPressed: () =>
                    controller.alternarFavorito(produto.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                produto.emoji,
                style: const TextStyle(fontSize: 100),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              produto.categoria,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              produto.descricao,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Adicionar ao carrinho'),
              onPressed: () {
                controller.adicionarAoCarrinho(produto.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto adicionado ao carrinho!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
