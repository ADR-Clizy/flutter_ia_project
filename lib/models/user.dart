class UserModel {
  final String? username;
  final String? email;
  final String? password;
  final String? birthday;
  final String? address;
  final String? postalCode;
  final String? city;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.birthday,
    required this.address,
    required this.postalCode,
    required this.city,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      birthday: map['birthday'],
      address: map['address'],
      postalCode: map['postalCode'],
      city: map['city'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'birthday': birthday,
      'address': address,
      'postalCode': postalCode,
      'city': city,
    };
  }
}
