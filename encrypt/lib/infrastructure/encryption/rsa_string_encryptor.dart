import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import 'package:pointycastle/export.dart';

class RSAStringEncryptingService {
  String encrypt(String painText, crypto.PublicKey publicKey) =>
      rsa.encrypt(painText, publicKey as RSAPublicKey);

  String decrypt(String cipherText, crypto.PrivateKey privateKey) =>
      rsa.decrypt(cipherText, privateKey as RSAPrivateKey);
}
