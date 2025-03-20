import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> saveNote() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Judul atau deskripsi tidak boleh kosong",
        btnOkOnPress: () {},
        btnOkText: "Ok",
      ).show();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    User? user = firebaseAuth.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        await firebaseFirestore
            .collection('users')
            .doc(uid)
            .collection('notes')
            .add({
              'title': title,
              'description': description,
              'timestamp': FieldValue.serverTimestamp(),
            });

        setState(() {
          _titleController.clear();
          _descriptionController.clear();
          _isLoading = false;
        });

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: "Catatan Berhasil Disimpan",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
          btnOkText: "Ok",
        ).show();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: "Gagal Menyimpan",
          desc: "Terjadi kesalahan: $e",
          btnOkOnPress: () {},
          btnOkText: "Ok",
        ).show();
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Gagal",
        desc: "Pengguna tidak terautentikasi",
        btnOkOnPress: () {},
        btnOkText: "Ok",
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah catatan"),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Judul",
                hintText: "Masukkan judul catatan anda",
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Catatan",
                hintText: "masukkan catatan anda",
              ),
            ),
            SizedBox(height: 12.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: saveNote,
                  child: Text("Simpan Catatan"),
                ),
          ],
        ),
      ),
    );
  }
}
