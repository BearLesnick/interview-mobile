import 'package:encrypt/bloc/main/facade.dart';
import 'package:encrypt/infrastructure/encryption/rsa_key_pair_generator.dart';
import 'package:encrypt/infrastructure/encryption/rsa_string_encryptor.dart';
import 'package:encrypt/infrastructure/key_value_storage.dart';
import 'package:encrypt/meta/di/container.dart';

class MainBlocFacadeFactory {
  //TODO(Zaika): use di to get encrypting classes
  MainBlocFacade create(DIContainer container) => MainBlocFacade(
        container.get<KeyValueStorage>(),
        RSAKeyPairGenerator(),
        RSAStringEncryptingService(),
      );
}
