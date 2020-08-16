import 'package:encrypt/application/di_application.dart';
import 'package:encrypt/infrastructure/sequre_key_value_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderDiApplication(
      storage:
          PreferencesKeyValueStorage(await SharedPreferences.getInstance())));
}
