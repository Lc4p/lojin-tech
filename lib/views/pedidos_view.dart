
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../locator.dart';
import '../models/pedido_model.dart';

class PedidosView extends StatelessWidget {
  final PedidoModel? pedidoRecente;

  const PedidosView({
    super.key,
    this.pedidoRecente,
  });

  static const azul = Color(0xFF1976D2);

  String moeda(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  String dataFormatada(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text('Meus pedidos'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final pedidos = controller.pedidos;

          if (pedidos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 72,
                      color: Color(0xFF90CAF9),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Você ainda não tem pedidos.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Suas compras aparecerão aqui.'),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pedidoRecente != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pedido realizado com sucesso!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF246B35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Histórico de compras',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF174A7E),
                ),
              ),
              const SizedBox(height: 12),
              ...pedidos.map((pedido) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0xFFE1EFFB),
                    ),
                  ),
                  child: ExpansionTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEAF5FF),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: azul,
                      ),
                    ),
                    title: Text(
                      'Pedido #${pedido.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${dataFormatada(pedido.data)} • ${pedido.status}',
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 16,
                    ),
                    children: [
                      const Divider(),
                      ...pedido.itens.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Text(
                            item.produto.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(item.produto.nome),
                          subtitle: Text(
                            '${item.quantidade} × '
                            '${moeda(item.produto.preco)}',
                          ),
                          trailing: Text(
                            moeda(item.subtotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                      const Divider(),
                      _Detalhe(
                        titulo: 'Entrega',
                        valor: pedido.endereco,
                      ),
                      _Detalhe(
                        titulo: 'Pagamento',
                        valor: pedido.formaPagamento,
                      ),
                      _Detalhe(
                        titulo: 'Status',
                        valor: pedido.status,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total do pedido',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            moeda(pedido.total),
                            style: const TextStyle(
                              color: azul,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Voltar à loja'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Detalhe extends StatelessWidget {
  final String titulo;
  final String valor;

  const _Detalhe({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              titulo,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
