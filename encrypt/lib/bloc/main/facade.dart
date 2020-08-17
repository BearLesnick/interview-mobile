import 'package:encrypt/bloc/main/key_pair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_encrypt_pair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_key_pair_generator.dart';
import 'package:encrypt/infrastructure/encryption/rsa_string_encryptor.dart';
import 'package:encrypt/infrastructure/key_value_storage.dart';

class MainBlocFacade {
  static const String _PublicKeyKey = "public_key_key";
  static const String _PrivateKeyKey = "private_key_key";

  final KeyValueStorage _storage;

  // TODO(Zaika): dependency inversion, replace by abstraction
  final RSAKeyPairGenerator _generator;

  final RSAStringEncryptingService _encryptingService;

  MainBlocFacade(this._storage, this._generator, this._encryptingService);

  Future<KeyPair> getStoredKeyPair() async {
    final String publicKey = await _storage.getString(key: _PublicKeyKey);
    final String privateKey = await _storage.getString(key: _PrivateKeyKey);
    if (publicKey != null && privateKey != null) {
      return KeyPair(privateKey: privateKey, publicKey: publicKey);
    } else
      throw Exception("KeyNotFound");
  }

  Future<String> encryptMessage(String plainText, String publicKey) async {
    return _encryptingService.encrypt(
        plainText, await _generator.publicKeyFromString(publicKey));
  }

  Future<void> storeKeyPair(KeyPair pair) async {
    _storage.putString(key: _PublicKeyKey, value: pair.publicKey);
    _storage.putString(key: _PrivateKeyKey, value: pair.privateKey);
  }

  Future<KeyPair> generateKeyPair() async {
    final RSAEncryptKeyPair pair = await _generator.generate();
    final KeyPair stringPair = await _generator.convertPairToString(pair);
    await storeKeyPair(stringPair);
    return stringPair;
  }
}
