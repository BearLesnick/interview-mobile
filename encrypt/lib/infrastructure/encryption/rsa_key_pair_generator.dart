import 'package:encrypt/bloc/main/key_pair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_encrypt_pair.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class RSAKeyPairGenerator {
  Future<RSAEncryptKeyPair> generate() async {
    final RsaKeyHelper helper = RsaKeyHelper();
    return RSAEncryptKeyPair(
        await helper.computeRSAKeyPair(helper.getSecureRandom()));
  }

  Future<KeyPair> convertPairToString(RSAEncryptKeyPair pair) async {
    final RsaKeyHelper helper = RsaKeyHelper();
    return KeyPair(
        privateKey: helper.encodePrivateKeyToPemPKCS1(pair.keyPair.privateKey as RSAPrivateKey),
        publicKey: helper.encodePublicKeyToPemPKCS1(pair.keyPair.publicKey as RSAPublicKey));
  }

  Future<crypto.PrivateKey> privateKeyFromString(String privateKey) async {
    final RsaKeyHelper helper = RsaKeyHelper();
    return helper.parsePrivateKeyFromPem(privateKey);
  }

  Future<crypto.PublicKey> publicKeyFromString(String publicKey) async {
    final RsaKeyHelper helper = RsaKeyHelper();
    return helper.parsePublicKeyFromPem(publicKey);
  }
}
