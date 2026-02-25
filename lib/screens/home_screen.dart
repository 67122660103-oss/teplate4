import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'profile_screen.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRegistered = false;
  String? _userData;

  @override
  void initState() {
    super.initState();
    _checkRegistration();
  }

  Future<void> _checkRegistration() async {
    final isRegistered = await StorageService.isRegistered();
    final userData = await StorageService.getUserData();
    setState(() {
      _isRegistered = isRegistered;
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validation Lab'),
        backgroundColor: Colors.blue[600],
        actions: [
          if (_isRegistered)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () async {
                await StorageService.clearData();
                _checkRegistration();
              },
              tooltip: 'ลบข้อมูลทดสอบ',
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isRegistered ? Icons.person : Icons.person_add,
                size: 120,
                color: _isRegistered ? Colors.green : Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                _isRegistered ? 'ลงทะเบียนสำเร็จ!' : 'ยินดีต้อนรับ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              if (_isRegistered) ...[
                Text(
                  _userData ?? '',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.visibility),
                  label: const Text('ดูข้อมูลผู้ใช้'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                ).then((_) => _checkRegistration()),
                icon: Icon(_isRegistered ? Icons.edit : Icons.person_add),
                label: Text(_isRegistered ? 'แก้ไขข้อมูล' : 'ลงทะเบียน'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
