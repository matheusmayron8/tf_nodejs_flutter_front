class UserCreateResponse {
  final id;

  const UserCreateResponse({required this.id});

  factory UserCreateResponse.fromJson(Map<String, dynamic> json) {
    return UserCreateResponse(id: json['id']);
  }
}
