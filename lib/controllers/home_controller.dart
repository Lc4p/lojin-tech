
import 'package:flutter/foundation.dart';

import '../models/produto_model.dart';
import '../models/pedido_model.dart';
import '../data/produtos_data.dart';

class HomeController extends ChangeNotifier {
  final List<ProdutoModel> _produtos = ProdutosData.produtos;
  
  final Set<int> _favoritos = {};
  final Map<int, int> _carrinho = {};
  final List<PedidoModel> _pedidos = [];

  String _busca = '';
  String _categoriaSelecionada = 'Todos';

  List<ProdutoModel> get produtos => List.unmodifiable(_produtos);
  Set<int> get favoritos => Set.unmodifiable(_favoritos);
  Map<int, int> get carrinho => Map.unmodifiable(_carrinho);
  List<PedidoModel> get pedidos => List.unmodifiable(_pedidos);

  String get busca => _busca;
  String get categoriaSelecionada => _categoriaSelecionada;

  int get quantidadeCarrinho =>
      _carrinho.values.fold(0, (soma, qtd) => soma + qtd);

  double get totalCarrinho {
    double total = 0;
    for (final produto in _produtos) {
      total += produto.preco * (_carrinho[produto.id] ?? 0);
    }
    return total;
  }

  List<String> get categorias => [
        'Todos',
        ..._produtos.map((p) => p.categoria).toSet(),
      ];

  List<ProdutoModel> get produtosFiltrados {
    return _produtos.where((produto) {
      final texto = '${produto.nome} ${produto.descricao}'.toLowerCase();
      final correspondeBusca = texto.contains(_busca.toLowerCase());
      final correspondeCategoria =
          _categoriaSelecionada == 'Todos' ||
          produto.categoria == _categoriaSelecionada;

      return correspondeBusca && correspondeCategoria;
    }).toList();
  }

  List<ProdutoModel> get produtosDestaque =>
      _produtos.where((p) => p.destaque).toList();

  List<ItemPedidoModel> get itensCarrinho => _produtos
      .where((p) => (_carrinho[p.id] ?? 0) > 0)
      .map((p) => ItemPedidoModel(
            produto: p,
            quantidade: _carrinho[p.id]!,
          ))
      .toList();

  void pesquisar(String texto) {
    _busca = texto.trim();
    notifyListeners();
  }

  void selecionarCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    notifyListeners();
  }

  void alternarFavorito(int id) {
    if (!_favoritos.add(id)) {
      _favoritos.remove(id);
    }
    notifyListeners();
  }

  bool ehFavorito(int id) => _favoritos.contains(id);

  void adicionarAoCarrinho(int id) {
    if (!_produtos.any((p) => p.id == id)) return;
    _carrinho[id] = (_carrinho[id] ?? 0) + 1;
    notifyListeners();
  }

  void removerDoCarrinho(int id) {
    final quantidade = _carrinho[id] ?? 0;

    if (quantidade <= 1) {
      _carrinho.remove(id);
    } else {
      _carrinho[id] = quantidade - 1;
    }

    notifyListeners();
  }

  void excluirDoCarrinho(int id) {
    _carrinho.remove(id);
    notifyListeners();
  }

  PedidoModel? finalizarCompra({
    required String endereco,
    required String formaPagamento,
  }) {
    if (_carrinho.isEmpty || endereco.trim().isEmpty) return null;

    final itens = itensCarrinho;
    final total = totalCarrinho;

    final pedido = PedidoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: DateTime.now(),
      itens: itens,
      endereco: endereco.trim(),
      formaPagamento: formaPagamento,
      total: total,
    );

    _pedidos.insert(0, pedido);
    _carrinho.clear();
    notifyListeners();

    return pedido;
  }
}
