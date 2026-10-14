
import 'package:flutter/material.dart';
import 'views/cadastro_view.dart';
import 'views/recuperacao_view.dart';
import 'locator.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/sobre_view.dart';
import 'views/perfil_view.dart';
import 'views/carrinho_view.dart';
import 'views/checkout_view.dart';
import 'views/pedidos_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(const LojinTechApp());
}

class LojinTechApp extends StatelessWidget {
  const LojinTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LojinTech',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF64B5F6),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1976D2),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/cadastro': (context) => const CadastroView(),
        '/recuperacao': (context) => const RecuperacaoView(),
        '/home': (context) => const HomeView(),
        '/sobre': (context) => const SobreView(),
        '/perfil': (context) => const PerfilView(),
        '/catalogo': (context) => const HomeView(),
        '/carrinho': (context) => const CarrinhoView(),
        '/checkout': (context) => const CheckoutView(),
        '/pedidos': (context) => const PedidosView(),
      },
    );
  }
}

class PlaceholderView extends StatelessWidget {
  final String titulo;

  const PlaceholderView({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(child: Text(titulo)),
    );
  }
}
