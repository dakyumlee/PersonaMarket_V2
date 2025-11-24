class User {
  final int id;
  final String email;
  final String username;
  final String? profileImage;
  final String? bio;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.profileImage,
    this.bio,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profileImage: json['profileImage'],
      bio: json['bio'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profileImage': profileImage,
      'bio': bio,
      'role': role,
    };
  }
}
