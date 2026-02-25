

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String province;
  final int age;
  final bool acceptTerms;
  final String gender;
  final double rating;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.province,
    required this.age,
    required this.acceptTerms,
    required this.gender,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'province': province,
      'age': age,
      'gender': gender,
      'rating': rating,
      'acceptTerms': acceptTerms,
    };
  }

  @override
  String toString() {
    return 'ชื่อ: $firstName $lastName\n'
        'อีเมล: $email\n'
        'เบอร์โทร: $phone\n'
        'จังหวัด: $province\n'
        'อายุ: $age\n'
        'เพศ: $gender\n'
        'คะแนน: ${rating.toStringAsFixed(1)}';
  }
}

