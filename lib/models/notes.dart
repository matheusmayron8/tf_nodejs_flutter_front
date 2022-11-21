class Notes {
  final int id;
  final String note;
  final int userId;
  bool completed;

  Notes(
      {required int this.id,
      required String this.note,
      required int this.userId,
      required bool this.completed});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
        id: json['id'],
        note: json['note'],
        userId: json['userid'],
        completed: json['completed']);
  }
}
