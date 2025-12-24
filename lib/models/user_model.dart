class AppUser {
  final String id;
  final String name;
  final String role;
  final String email;

  AppUser({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'role': role,
        'email': email,
      };

  factory AppUser.fromMap(Map data, String id) {
    return AppUser(
      id: id,
      name: data['name'],
      role: data['role'],
      email: data['email'],
    );
  }
}
