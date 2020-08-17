import 'package:encrypt/flutter/page/main/page.dart';
import 'package:encrypt/infrastructure/key_value_storage.dart';
import 'package:encrypt/meta/message_registry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderDiApplication extends StatefulWidget {
  final KeyValueStorage storage;

  const ProviderDiApplication({Key key, this.storage}) : super(key: key);

  @override
  _ProviderDiApplicationState createState() => _ProviderDiApplicationState();
}

class _ProviderDiApplicationState extends State<ProviderDiApplication> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Provider<dynamic>>[
        Provider<KeyValueStorage>.value(
          value: widget.storage,
          updateShouldNotify: (KeyValueStorage first, KeyValueStorage second) =>
              first != second,
        ),
        Provider<MessagesRegistry>.value(value: ConstMessagesRegistry()),
      ],
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}
