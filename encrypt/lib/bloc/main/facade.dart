import 'dart:convert';

import 'package:encrypt/bloc/main/keyPair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_encrypt_pair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_key_pair_generator.dart';
import 'package:encrypt/infrastructure/encryption/rsa_string_encryptor.dart';
import 'package:encrypt/infrastructure/key_value_storage.dart';
class MainBlocFacade {
  static const String PublicKeyKey = "public_key_key";
  static const String PrivateKeyKey = "private_key_key";

  final KeyValueStorage storage;

  //TODO(Zaika): dependency inversion, replace by abstraction
  final RSAKeyPairGenerator generator;

  final RSAStringEncryptingService _encryptingService;

  MainBlocFacade(this.storage, this.generator, this._encryptingService);

  Future<KeyPair> getKeyPair() async {
    String publicKey = await storage.getString(key: PublicKeyKey);
    String privateKey = await storage.getString(key: PrivateKeyKey);
    if (publicKey != null && privateKey != null) {
      return KeyPair(privateKey: privateKey, publicKey: publicKey);
    } else
      throw Exception("KeyNotFound");
  }

  Future<String> encryptMessage(String plainText, String publicKey) async {
    return _encryptingService.encrypt(
        plainText, await generator.publicKeyFromString(publicKey));
  }

  Future<void> storeKeyPair(KeyPair pair) async {
    storage.putString(key: PublicKeyKey, value: pair.publicKey);
    storage.putString(key: PrivateKeyKey, value: pair.privateKey);
  }

  Future<KeyPair> generateKeyPair() async {
    RSAEncryptKeyPair pair = await generator.generate();
    KeyPair stringPair = await generator.convertPairToString(pair);
    await storeKeyPair(stringPair);
    return stringPair;
  }
}
