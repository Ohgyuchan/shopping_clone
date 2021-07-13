import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = new FlutterSecureStorage();

  // Storage에 저장되는 것은 무조건 String 값으로 저장되고 불러오는 것도 String으로만 불러올 수 있다.
  Future<String?> getStoredValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (error) {
      return null;
    }
  }

  Future<void> storeValue(String key, String value) async {
    try {
      return await storage.write(key: key, value: value);
    } catch (error) {
      return null;
    }
  }
}
