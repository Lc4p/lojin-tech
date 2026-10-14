
class ProdutoModel {
  final int id;
  final String nome;
  final String categoria;
  final double preco;
  final String descricao;
  final String emoji;
  final bool destaque;

  const ProdutoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.descricao,
    required this.emoji,
    this.destaque = false,
  });
}
