import 'package:equatable/equatable.dart';

class KeyPair with EquatableMixin {
  final String privateKey;
  final String publicKey;

  KeyPair({this.privateKey, this.publicKey});

  @override
  List<Object> get props => <Object>[privateKey, publicKey];
}
