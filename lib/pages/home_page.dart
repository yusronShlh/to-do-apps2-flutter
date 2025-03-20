import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _confirmLogout() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "Konfirmasi Logout",
      desc: "Apakah Anda yakin ingin logout?",
      btnCancelOnPress: () {},
      btnCancelText: "Tidak",
      btnOkOnPress: () async {
        await _auth.signOut();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      btnOkText: "Ya, Logout",
      btnOkColor: Colors.red,
    ).show();
  }

  void _deleteNote(String docId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "Konfirmasi Hapus",
      desc: "Apakah Anda yakin ingin menghapus catatan ini?",
      btnCancelOnPress: () {},
      btnCancelText: "Batal",
      btnOkOnPress: () async {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('notes')
            .doc(docId)
            .delete();
      },
      btnOkText: "Hapus",
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catatan Harian",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .collection('notes')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Belum ada catatan, tambahkan sekarang!"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(doc['title']),
                  subtitle: Text(doc['description']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        backgroundColor: Colors.blue.shade300,
        child: Icon(Icons.add),
      ),
    );
  }
}
