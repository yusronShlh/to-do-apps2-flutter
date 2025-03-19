import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  // Login dengan Email dan Password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Login berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email tidak terdaftar.';
      } else if (e.code == 'wrong-password') {
        return 'Password salah.';
      } else {
        return 'Terjadi kesalahan. Coba lagi.';
      }
    }
  }

  // Registrasi dengan Email dan Password
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Registrasi berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email sudah digunakan.';
      } else if (e.code == 'weak-password') {
        return 'Gunakan password yang lebih kuat.';
      } else {
        return 'Terjadi kesalahan. Coba lagi.';
      }
    }
  }

  // 🔹 Pendaftaran dengan Google (Hanya untuk akun baru)
  Future<String?> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Pendaftaran dengan Google dibatalkan.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Cek apakah email sudah terdaftar di Firebase
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
        googleUser.email,
      );
      if (signInMethods.isNotEmpty) {
        return 'Akun ini sudah terdaftar. Silakan login.';
      }

      await _auth.signInWithCredential(credential);
      notifyListeners();
      return null; // Pendaftaran berhasil
    } catch (e) {
      return 'Gagal mendaftar dengan Google. Coba lagi.';
    }
  }

  // 🔹 Login dengan Google
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Login dengan Google dibatalkan.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      notifyListeners();
      return null; // Login berhasil
    } catch (e) {
      return 'Gagal login dengan Google. Coba lagi.';
    }
  }

  // Logout dari aplikasi
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
