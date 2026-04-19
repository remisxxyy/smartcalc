import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static Future<void> add(String text) async {
    final uid = _uid;

    if (uid == null) {
      return;
    }

    await _db.collection("history").add({
      "userId": uid,
      "text": text,
      "time": DateTime.now().toString(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getHistory() {
    final uid = _uid;

    if (uid == null) {
      return const Stream.empty();
    }

    return _db
        .collection("history")
        .where("userId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}