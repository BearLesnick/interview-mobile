import 'package:pointycastle/api.dart' as crypto;

class RSAEncryptKeyPair {
  final crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey> keyPair;

  RSAEncryptKeyPair(this.keyPair);

  String get privateKey => keyPair.privateKey.toString();

  String get publicKey => keyPair.publicKey.toString();
}
