import 'package:encrypt/infrastructure/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesKeyValueStorage implements KeyValueStorage {
  final SharedPreferences preferences;

  PreferencesKeyValueStorage(this.preferences);

  @override
  Future<String> getString({String key}) async => preferences.getString(key);

  @override
  Future<void> putString({String key, String value}) async =>
      preferences.setString(key, value);
}
