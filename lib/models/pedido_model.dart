
import 'produto_model.dart';

class ItemPedidoModel {
  final ProdutoModel produto;
  final int quantidade;

  const ItemPedidoModel({
    required this.produto,
    required this.quantidade,
  });

  double get subtotal => produto.preco * quantidade;
}

class PedidoModel {
  final String id;
  final DateTime data;
  final List<ItemPedidoModel> itens;
  final String endereco;
  final String formaPagamento;
  final double total;
  final String status;

  PedidoModel({
    required this.id,
    required this.data,
    required List<ItemPedidoModel> itens,
    required this.endereco,
    required this.formaPagamento,
    required this.total,
    this.status = 'Confirmado',
  }) : itens = List.unmodifiable(itens);
}
