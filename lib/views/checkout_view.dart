
import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../locator.dart';
import 'pedidos_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _endereco = TextEditingController();

  String _pagamento = 'Pix';

  static const azul = Color(0xFF1976D2);

  String moeda(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  void dispose() {
    _endereco.dispose();
    super.dispose();
  }

  void _confirmarCompra() {
  if (!_formKey.currentState!.validate()) return;

  final controller = getIt<HomeController>();

  final pedido = controller.finalizarCompra(
    endereco: _endereco.text,
    formaPagamento: _pagamento,
  );

  if (pedido == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Não foi possível finalizar a compra.',
        ),
      ),
    );
    return;
  }

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => PedidosView(
        pedidoRecente: pedido,
      ),
    ),
    (route) => route.isFirst,
  );
}

  @override
  Widget build(BuildContext context) {
    final controller = getIt<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: azul,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.quantidadeCarrinho == 0) {
            return const Center(
              child: Text('Adicione produtos antes de finalizar a compra.'),
            );
          }

          return SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Endereço de entrega',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF174A7E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _endereco,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Rua, número, bairro, cidade e CEP',
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: azul,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().length < 8) {
                        return 'Informe um endereço completo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Forma de pagamento',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF174A7E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...['Pix', 'Cartão de crédito (simulado)', 'Boleto (simulado)']
                      .map(
                    (forma) => Card(
                      color: Colors.white,
                      child: RadioListTile<String>(
                        value: forma,
                        groupValue: _pagamento,
                        activeColor: azul,
                        title: Text(forma),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() => _pagamento = valor);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resumo da compra',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Itens: ${controller.quantidadeCarrinho}',
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total'),
                              Text(
                                moeda(controller.totalCarrinho),
                                style: const TextStyle(
                                  color: azul,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Pagamento e entrega demonstrativos. '
                            'Nenhuma cobrança real será realizada.',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: _confirmarCompra,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Confirmar pedido'),
                      style: FilledButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
