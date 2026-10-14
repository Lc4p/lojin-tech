
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../locator.dart';
import '../models/produto_model.dart';

import 'sobre_view.dart';
import 'perfil_view.dart';
import 'carrinho_view.dart';
import 'pedidos_view.dart';
import 'produto_detalhe_view.dart';
import 'favoritos_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = getIt<HomeController>();

  static const azul = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: azul,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.computer_rounded, size: 30),
            SizedBox(width: 8),
            Text(
              'LojinTech',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Favoritos
          IconButton(
            tooltip: 'Meus favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritosView(),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),

          // Perfil
          IconButton(
            tooltip: 'Meu perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PerfilView(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),

          // Sobre
          IconButton(
            tooltip: 'Sobre o aplicativo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SobreView(),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),

          // Pedidos
          IconButton(
            tooltip: 'Meus pedidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PedidosView(),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long_outlined),
          ),

          // Carrinho com contador de itens
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    tooltip: 'Carrinho',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CarrinhoView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (controller.quantidadeCarrinho > 0)
                    Positioned(
                      right: 4,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${controller.quantidadeCarrinho}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final produtos = controller.produtosFiltrados;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sua próxima coleção começa aqui!',
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF174A7E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Encontre cards, bonecos e itens colecionáveis.',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Busca
                        TextField(
                          onChanged: controller.pesquisar,
                          decoration: InputDecoration(
                            hintText: 'Buscar produtos...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: azul,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFD6E9FA),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFD6E9FA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: azul,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Categorias
                        const Text(
                          'Categorias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF174A7E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categorias.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final categoria =
                                  controller.categorias[index];

                              final selecionada =
                                  controller.categoriaSelecionada ==
                                      categoria;

                              return ChoiceChip(
                                label: Text(categoria),
                                selected: selecionada,
                                onSelected: (_) => controller
                                    .selecionarCategoria(categoria),
                                selectedColor: azul,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: selecionada
                                      ? Colors.white
                                      : azul,
                                  fontWeight: FontWeight.w600,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFD6E9FA),
                                ),
                                showCheckmark: false,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Título e quantidade de produtos
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.busca.isNotEmpty ||
                                      controller.categoriaSelecionada !=
                                          'Todos'
                                  ? 'Resultados'
                                  : 'Nossos produtos',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF174A7E),
                              ),
                            ),
                            Text(
                              '${produtos.length} itens',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),

                // Nenhum produto encontrado
                if (produtos.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 56,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nenhum produto encontrado.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tente outra busca ou categoria.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  // Grade de produtos
                  SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final largura = constraints.crossAxisExtent;
                        final colunas = largura >= 650 ? 3 : 2;

                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: colunas,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 310,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _ProdutoCard(
                                produto: produtos[index],
                                controller: controller,
                              );
                            },
                            childCount: produtos.length,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProdutoCard extends StatelessWidget {
  final ProdutoModel produto;
  final HomeController controller;

  const _ProdutoCard({
    required this.produto,
    required this.controller,
  });

  static const azul = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: azul.withValues(alpha: 0.10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE1EFFB)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        // Ao clicar no produto, abre a tela de detalhes.
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProdutoDetalheView(
                produto: produto,
              ),
            ),
          );
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFEAF5FF),
                    child: Center(
                      child: Text(
                        produto.emoji,
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                  ),

                  // Selo de destaque
                  if (produto.destaque)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: azul,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Destaque',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Botão de favoritar
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      tooltip: controller.ehFavorito(produto.id)
                          ? 'Remover dos favoritos'
                          : 'Adicionar aos favoritos',
                      onPressed: () {
                        controller.alternarFavorito(produto.id);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.9),
                      ),
                      icon: Icon(
                        controller.ehFavorito(produto.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: controller.ehFavorito(produto.id)
                            ? Colors.redAccent
                            : azul,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informações do produto
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.categoria,
                    style: const TextStyle(
                      color: azul,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produto.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Adicionar ao carrinho
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: FilledButton.icon(
                      onPressed: () {
                        controller.adicionarAoCarrinho(produto.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${produto.nome} adicionado ao carrinho!',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 16,
                      ),
                      label: const Text(
                        'Adicionar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
