
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../locator.dart';
import 'produto_detalhe_view.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus favoritos'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final favoritos = controller.produtos
              .where((produto) => controller.ehFavorito(produto.id))
              .toList();

          if (favoritos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Você ainda não tem favoritos.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Toque no coração de um produto para salvá-lo aqui.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              final produto = favoritos[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Text(
                    produto.emoji,
                    style: const TextStyle(fontSize: 35),
                  ),
                  title: Text(
                    produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProdutoDetalheView(produto: produto),
                      ),
                    );
                  },
                  trailing: Wrap(
                    spacing: 0,
                    children: [
                      IconButton(
                        tooltip: 'Adicionar ao carrinho',
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          controller.adicionarAoCarrinho(produto.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Produto adicionado ao carrinho!',
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Remover dos favoritos',
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            controller.alternarFavorito(produto.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
