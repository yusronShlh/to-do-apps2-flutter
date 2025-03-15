import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _controller = TextEditingController();

  void _saveNote() {
    if (_controller.text.trim().isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Peringatan",
        desc: "Catatan tidak boleh kosong atau hanya berisi spasi!",
        btnOkOnPress: () {},
        btnOkText: "OK",
      ).show();
    } else {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Catatan"),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Masukkan catatan",
                hintText: "Catatan tidak boleh kosong atau hanya berisi spasi!",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
