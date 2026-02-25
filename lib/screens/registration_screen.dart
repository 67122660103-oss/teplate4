import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../widget/custom_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedProvince = 'กรุงเทพมหานคร';
  String _selectedGender = 'ชาย';
  bool _acceptTerms = false;
  double _ageSlider = 25;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  final List<String> _provinces = [
    'กรุงเทพมหานคร', 'เชียงใหม่', 'ขอนแก่น', 'ชลบุรี', 'นครราชสีมา'
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = User(
        firstName: _nameController.text.split(' ')[0],
        lastName: _nameController.text.contains(' ') 
            ? _nameController.text.split(' ')[1] 
            : '',
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        province: _selectedProvince,
        age: _ageSlider.round(),
        acceptTerms: _acceptTerms,
        gender: _selectedGender,
        rating: _ageSlider,
      );

      await StorageService.saveUser(user);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ลงทะเบียนสำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนผู้ใช้'),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ชื่อ-นามสกุล
              CustomFormField(
                label: 'ชื่อ-นามสกุล',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ-นามสกุล';
                  }
                  if (value.length < 6) {
                    return 'ชื่อ-นามสกุลต้องมีอย่างน้อย 6 ตัวอักษร';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // อีเมล
              CustomFormField(
                label: 'อีเมล',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'รูปแบบอีเมลไม่ถูกต้อง';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // เบอร์โทร
              CustomFormField(
                label: 'เบอร์โทร',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                prefixIcon: Icons.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทร';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'เบอร์โทรต้องมี 10 หลัก';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // รหัสผ่าน
              CustomFormField(
                label: 'รหัสผ่าน',
                obscureText: true,
                controller: _passwordController,
                prefixIcon: Icons.lock,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  if (value.length < 6) {
                    return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // เพศ
              const Text('เพศ:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('ชาย'),
                value: 'ชาย',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('หญิง'),
                value: 'หญิง',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // จังหวัด
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: const InputDecoration(
                  labelText: 'จังหวัด',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                validator: (value) => value == null ? 'กรุณาเลือกจังหวัด' : null,
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // อายุ Slider
              const Text('อายุ:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: _ageSlider,
                min: 18,
                max: 80,
                divisions: 62,
                label: '${_ageSlider.round()} ปี',
                onChanged: (value) {
                  setState(() {
                    _ageSlider = value;
                  });
                },
              ),
              Text('อายุ: ${_ageSlider.round()} ปี', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Checkbox เงื่อนไข
              CheckboxListTile(
                title: const Text('ยอมรับเงื่อนไขการใช้งาน'),
                subtitle: const Text('คุณต้องยอมรับก่อนลงทะเบียน'),
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value!;
                  });
                },
                secondary: const Icon(Icons.check_circle, color: Colors.green),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 32),

              // ปุ่ม Submit
              ElevatedButton(
                onPressed: _acceptTerms ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ลงทะเบียน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // Toggle Autovalidate
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _autoValidate = _autoValidate == AutovalidateMode.disabled
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled;
                  });
                },
                icon: Icon(_autoValidate == AutovalidateMode.disabled
                    ? Icons.visibility
                    : Icons.visibility_off),
                label: Text(_autoValidate == AutovalidateMode.disabled
                    ? 'เปิด Auto Validate'
                    : 'ปิด Auto Validate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
