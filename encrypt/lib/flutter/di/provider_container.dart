import 'package:encrypt/meta/di/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderContainer implements DIContainer {
  final BuildContext context;
  final bool shouldListen;

  ProviderContainer(this.context, {this.shouldListen = false});

  @override
  T get<T>() => Provider.of<T>(context, listen: shouldListen);
}
