import 'package:encrypt/assembly/bloc/main/bloc.dart';
import 'package:encrypt/bloc/main/main.dart';
import 'package:encrypt/flutter/di/provider_container.dart';
import 'package:encrypt/flutter/page/main/widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MainPageBlocFactory()
        .create(ProviderContainer(context));
  }


  @override
  Widget build(BuildContext context) {
    return MainPageWidget(bloc: _bloc);
  }
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
