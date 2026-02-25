import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _isRegisteredKey = 'is_registered';

  // บันทึกข้อมูลผู้ใช้
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toString());
    await prefs.setBool(_isRegisteredKey, true);
  }

  // ตรวจสอบว่าลงทะเบียนแล้วหรือไม่
  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isRegisteredKey) ?? false;
  }

  // อ่านข้อมูลผู้ใช้
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // ลบข้อมูล (สำหรับทดสอบ)
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isRegisteredKey);
  }
}
