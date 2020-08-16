import 'package:encrypt/assembly/bloc/main/facade.dart';
import 'package:encrypt/bloc/main/main.dart';
import 'package:encrypt/meta/di/container.dart';

class MainPageBlocFactory {
  MainPageBloc create(DIContainer container) =>
      MainPageBloc(MainBlocFacadeFactory().create(container));
}
