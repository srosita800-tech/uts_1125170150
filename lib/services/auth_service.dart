import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter untuk mendapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream untuk memantau perubahan status auth secara real-time
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============ REGISTER ============
  Future<UserCredential?> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============ LOGIN ============
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============ LOGOUT ============
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============ RESET PASSWORD ============
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ============ ERROR HANDLER (Custom Messages) ============
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan register terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah. Coba lagi.';
      case 'invalid-credential': // Tambahan untuk Firebase versi terbaru
        return 'Email atau password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba beberapa saat lagi.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
