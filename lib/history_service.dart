import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String get _uid => FirebaseAuth.instance.currentUser!.uid;

  static Future<void> add(String text) async {
    await _db.collection("history").add({
      "userId": _uid,
      "text": text,
      "time": DateTime.now().toString(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getHistory() {
    return _db
        .collection("history")
        .where("userId", isEqualTo: _uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}