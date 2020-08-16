import 'package:encrypt/bloc/main/keyPair.dart';
import 'package:encrypt/infrastructure/encryption/rsa_encrypt_pair.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

class RSAKeyPairGenerator {
  Future<RSAEncryptKeyPair> generate() async {
    RsaKeyHelper helper = RsaKeyHelper();
    return RSAEncryptKeyPair(
        await helper.computeRSAKeyPair(helper.getSecureRandom()));
  }

  Future<KeyPair> convertPairToString(RSAEncryptKeyPair pair) async {
    RsaKeyHelper helper = RsaKeyHelper();
    return KeyPair(
        privateKey: helper.encodePrivateKeyToPemPKCS1(pair.keyPair.privateKey),
        publicKey: helper.encodePublicKeyToPemPKCS1(pair.keyPair.publicKey));
  }

  Future<crypto.PrivateKey> privateKeyFromString(String privateKey) async {
    RsaKeyHelper helper = RsaKeyHelper();
    return helper.parsePrivateKeyFromPem(privateKey);
  }

  Future<crypto.PublicKey> publicKeyFromString(String publicKey) async {
    RsaKeyHelper helper = RsaKeyHelper();
    return helper.parsePublicKeyFromPem(publicKey);
  }
}
