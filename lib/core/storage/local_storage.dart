// lib/core/storage/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // Guardar dato string
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Obtener dato string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Guardar dato bool
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Obtener dato bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Guardar dato int
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // Obtener dato int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Guardar dato double
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // Obtener dato double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Guardar lista de strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Obtener lista de strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Eliminar dato
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Limpiar todos los datos
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Verificar si existe una clave
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}