
import 'package:get_it/get_it.dart';

import 'controllers/home_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/cadastro_controller.dart';
import 'controllers/recuperacao_controller.dart';
import 'services/usuario_repository.dart';
import 'controllers/sessao_controller.dart';
import 'controllers/perfil_controller.dart';
import 'models/usuario_model.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  if (!getIt.isRegistered<UsuarioRepository>()) {
    getIt.registerLazySingleton<UsuarioRepository>(
      () => UsuarioRepository(),
    );
  }

  if (!getIt.isRegistered<LoginController>()) {
    getIt.registerLazySingleton<LoginController>(
      () => LoginController(),
    );
  }

  if (!getIt.isRegistered<CadastroController>()) {
    getIt.registerLazySingleton<CadastroController>(
      () => CadastroController(),
    );
  }

  if (!getIt.isRegistered<RecuperacaoController>()) {
    getIt.registerLazySingleton<RecuperacaoController>(
      () => RecuperacaoController(),
    );
  }

  if (!getIt.isRegistered<HomeController>()) {
  getIt.registerLazySingleton<HomeController>(
    () => HomeController(),
    );
  }

  if (!getIt.isRegistered<SessaoController>()) {
  getIt.registerLazySingleton<SessaoController>(
      () => SessaoController(),
    );
  }

  getIt.registerFactoryParam<PerfilController, UsuarioModel, void>(
    (usuario, _) => PerfilController(usuario: usuario),
  );
  
}
