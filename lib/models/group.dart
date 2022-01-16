class Group {
  String groupCode;
  List<String> users;
  List<String> distractedUsers;

  Group({
    required this.groupCode,
    required this.users,
    required this.distractedUsers
  });

  Group.fromJson(Map json) : 
    groupCode = json["code"],
    users = json["users"].cast<String>(),
    distractedUsers = json["distracted-users"].cast<String>();

  Map<String, dynamic> toJson() {
    return {
      "code": groupCode,
      "users": users,
      "distracted-users": distractedUsers
    };
  }
}