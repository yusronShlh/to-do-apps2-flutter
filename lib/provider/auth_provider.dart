import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Berarti login berhasil
    } on FirebaseAuthException catch (e) {
      // Tangkap error yang diberikan oleh Firebase
      if (e.code == 'user-not-found') {
        return 'Email tidak terdaftar.';
      } else if (e.code == 'wrong-password') {
        return 'Password salah.';
      } else {
        return 'Terjadi kesalahan. Coba lagi.';
      }
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Berarti registrasi berhasil
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

  Future<void> logout() async {
    await _auth.signOut();
  }
}
