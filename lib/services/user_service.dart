import 'package:firebase_database/firebase_database.dart';
import 'package:generic_company_application/models/user_model.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final DatabaseReference _db = FirebaseDatabase.instance.ref().child("users");

  /// ADD USER (ON SIGNUP)
  Future<void> addUser(AppUser user) async {
    await _db.child(user.id).set(user.toMap());
  }

  /// GET USER BY ID
  Future<AppUser?> getUserById(String uid) async {
    final snapshot = await _db.child(uid).get();
    if (!snapshot.exists) return null;

    return AppUser.fromMap(
      Map<String, dynamic>.from(snapshot.value as Map),
      uid,
    );
  }

  /// GET ALL MANAGERS
  Future<List<AppUser>> getManagers() async {
    final snapshot = await _db.orderByChild("role").equalTo("Manager").get();

    if (!snapshot.exists) return [];

    final data = snapshot.value as Map;
    return data.entries.map((e) => AppUser.fromMap(e.value, e.key)).toList();
  }

  /// GET ALL ADMINS
  Future<List<AppUser>> getAdmins() async {
    final snapshot = await _db.orderByChild("role").equalTo("Admin").get();

    if (!snapshot.exists) return [];

    final data = snapshot.value as Map;
    return data.entries.map((e) => AppUser.fromMap(e.value, e.key)).toList();
  }
}
