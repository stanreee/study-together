import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupstudy/exceptions/exceptions.dart';
import 'package:groupstudy/models/group.dart';
import 'package:groupstudy/models/user.dart';

class DatabaseRepository {
  late FirebaseFirestore firestore;

  late CollectionReference users;
  late CollectionReference groups;

  DatabaseRepository({required this.firestore}) {
    users = firestore.collection("users");
    groups = firestore.collection("groups");
  }

  Future<AppUser?> getUserByDisplayName(String displayName) async {
    QuerySnapshot userQuery = await users.where('displayName', isEqualTo: displayName).get();
    if(userQuery.size != 1) throw UserException(cause: "The user cannot be found.");
    for (var doc in userQuery.docs) {
      AppUser user = AppUser.fromJson(doc.data() as Map<String, dynamic>);
      return user;
    }
  }

  Future<void> setDistracted(Group group, String uid) async {
    QuerySnapshot groupQuery = await groups.where('code', isEqualTo: group.groupCode).get();
    DocumentReference docRef = groupQuery.docs[0].reference;
    await docRef.update({
      'distracted-users': FieldValue.arrayUnion([uid])
    });
  }

  Future<bool> userInDatabase(User user) async {
    QuerySnapshot userQuery = await users.where('uid', isEqualTo: user.uid).get();
    return userQuery.size == 1;
  }

  Future<void> createUser(User user, String displayName) async {
    AppUser appUser = AppUser(displayName: displayName, email: user.email!, groupID: "", uid: user.uid);
    await users.doc().set(appUser.toJson());
  }

  Future<bool> doesGroupExist(String code) async {
    QuerySnapshot groupQuery = await groups.where('code', isEqualTo: code).get();
    if(groupQuery.size != 1) return false;
    return true;
  }

  Future<Group> getGroup(String code) async {
    QuerySnapshot groupQuery = await groups.where('code', isEqualTo: code).get();
    return Group.fromJson(groupQuery.docs[0].data() as Map<String, dynamic>);
  }

  Future<Group> joinGroup(String code, AppUser user) async {
    QuerySnapshot groupQuery = await groups.where('code', isEqualTo: code).get();
    DocumentReference groupRef = groupQuery.docs[0].reference;
    await groupRef.update({
      'users': FieldValue.arrayUnion([user.uid])
    });
    QuerySnapshot userQuery = await users.where('uid', isEqualTo: user.uid).get();
    DocumentReference userRef = userQuery.docs[0].reference;
    await userRef.update({
      'group-id': code
    });
    Group group = await getGroup(code);
    return group;
  } 

  Future<void> createGroup(Group g) async {
    await groups.doc().set(g.toJson());
  } 

  Future<String> generateUniqueCode() async {
    String random;
    while(true) {
      random = getRandomString(5);
      QuerySnapshot groupQuery = await groups.where('code', isEqualTo: random).get();
      if(groupQuery.size == 0) break;
    }
    return random;
  }

  // below code courtesy of stackoverflow: https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
  String _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random(); 

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}