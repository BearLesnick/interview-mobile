abstract class MessagesRegistry {
  String encryptText();

  String generateKeyPair();

  String viewPrivateKey();

  String viewPublicKey();

  String displayTextInThisBox();
}

class ConstMessagesRegistry implements MessagesRegistry {
  @override
  String encryptText() => "Encrypt Text";

  @override
  String generateKeyPair() => "Generate Key Pair";

  @override
  String viewPrivateKey() => "View Private Key";

  @override
  String viewPublicKey() => "View Public Key";

  @override
  String displayTextInThisBox() => "Display text in this box";
}
