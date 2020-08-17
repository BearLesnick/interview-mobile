import 'package:encrypt/assembly/bloc/main/bloc.dart';
import 'package:encrypt/bloc/main/main.dart';
import 'package:encrypt/flutter/di/provider_container.dart';
import 'package:encrypt/flutter/page/main/widget.dart';
import 'package:encrypt/meta/message_registry.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainPageBloc _bloc;
  MessagesRegistry _registry;

  @override
  void initState() {
    super.initState();
    _bloc = MainPageBlocFactory().create(ProviderContainer(context));
    _registry = ProviderContainer(context).get<MessagesRegistry>();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageWidget(
      bloc: _bloc,
      messagesRegistry: _registry,
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
