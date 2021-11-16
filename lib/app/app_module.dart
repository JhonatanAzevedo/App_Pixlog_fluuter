import 'package:flutter_modular/flutter_modular.dart';
import '../splash_page.dart';
import 'module/home/home_module.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (ctx, args) => SplashPage()),
        ModuleRoute('/home', module: HomeModule()),
      ];
}
