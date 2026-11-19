import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref('devices');

  // تسجيل الدخول
  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user;
  }

  // تسجيل الخروج
  Future<void> signOut() async => await _auth.signOut();

  // قراءة بيانات البيت كله لحظياً
  Stream<DatabaseEvent> getDevicesStream() => _db.onValue;

  // إرسال أمر لأي جهاز
  Future<void> updateDevice(String path, dynamic value) async {
    await _db.child(path).set(value);
  }
}
