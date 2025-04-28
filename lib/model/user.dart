
 import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String confirmpas;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.confirmpas,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'confirmpas': confirmpas,
      'token': token,
    };
  }

 factory User.fromMap(Map<String, dynamic> map) {
  return User(
    id: map['id'] ?? 0,
    name: map['username'] ?? '',  
    email: map['email'] ?? '',
    password: map['password'] ?? '',
    phone: map['phoneNumber'] ?? '',  
    confirmpas: '',  
    token: map['token'] ?? '',
  );
}


  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) {
    try {
      return User.fromMap(json.decode(source));
    } catch (e) {
      throw Exception("Error parsing user JSON: $e");
    }
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? confirmpas,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      confirmpas: confirmpas ?? this.confirmpas,
      token: token ?? this.token,
    );
  }
}
