class AppUser {
  String displayName;
  String email;
  String groupID;
  String uid;

  AppUser({
    required this.displayName, 
    required this.email, 
    required this.groupID,
    required this.uid
  });

  AppUser.fromJson(Map json) :
    displayName = json['displayName'],
    email = json['email'],
    groupID = json['group-id'],
    uid = json['uid'];

  Map<String, dynamic> toJson() {
    return {
      "displayName": displayName,
      "email": email,
      "group-id": groupID,
      "uid": uid
    };
  }
}