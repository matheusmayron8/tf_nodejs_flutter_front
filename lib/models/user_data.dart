class UserData {
  final id;
  final String login;
  final String roles;
  final String token;

  const UserData({
    required this.id,
    required this.login,
    required this.roles,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      login: json['login'],
      roles: json['roles'],
      token: json['token'],
    );
  }
}
