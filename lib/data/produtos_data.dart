import '../models/produto_model.dart';

class ProdutosData {
  static const List<ProdutoModel> produtos = [
    ProdutoModel(
      id: 1,
      nome: 'Booster Pokémon',
      categoria: 'Cards',
      preco: 29.90,
      descricao: 'Pacote de cards colecionáveis.',
      emoji: '🃏',
      destaque: true,
    ),
    ProdutoModel(
      id: 2,
      nome: 'Coleção Pikachu',
      categoria: 'Cards',
      preco: 49.90,
      descricao: 'Coleção especial para fãs.',
      emoji: '⚡',
      destaque: true,
    ),
    ProdutoModel(
      id: 3,
      nome: 'Boneco colecionável',
      categoria: 'Bonecos',
      preco: 89.90,
      descricao: 'Boneco para decorar sua coleção.',
      emoji: '🧸',
    ),
    ProdutoModel(
      id: 4,
      nome: 'Miniatura gamer',
      categoria: 'Miniaturas',
      preco: 39.90,
      descricao: 'Miniatura para sua estante.',
      emoji: '🎮',
    ),
    ProdutoModel(
      id: 5,
      nome: 'Álbum de cards',
      categoria: 'Acessórios',
      preco: 34.90,
      descricao: 'Organize e proteja seus cards.',
      emoji: '📔',
    ),
    ProdutoModel(
      id: 6,
      nome: 'Figura de batalha',
      categoria: 'Bonecos',
      preco: 119.90,
      descricao: 'Figura para ampliar sua coleção.',
      emoji: '🤖',
      destaque: true,
    ),
    ProdutoModel(
      id: 7,
      nome: 'Sleeves para cards',
      categoria: 'Acessórios',
      preco: 19.90,
      descricao: 'Capas protetoras para cards.',
      emoji: '🛡️',
    ),
    ProdutoModel(
      id: 8,
      nome: 'Caixa de coleção',
      categoria: 'Acessórios',
      preco: 59.90,
      descricao: 'Caixa para guardar suas peças.',
      emoji: '📦',
    ),
  ];
}