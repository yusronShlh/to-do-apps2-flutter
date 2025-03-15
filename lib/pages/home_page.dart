import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'login_page.dart';
import 'add_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _showWelcomeDialog();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> _addNote(String note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes.add(note);
    await prefs.setStringList('notes', notes);
    setState(() {});
  }

  Future<void> _editNote(int index, String newNote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes[index] = newNote;
    await prefs.setStringList('notes', notes);
    setState(() {});
  }

  Future<void> _deleteNote(int index) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "Konfirmasi Hapus",
      desc: "Apakah Anda yakin ingin menghapus catatan ini?",
      btnCancelOnPress: () {},
      btnCancelText: "Batal",
      btnOkOnPress: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        notes.removeAt(index);
        await prefs.setStringList('notes', notes);
        setState(() {});
      },
      btnOkText: "Hapus",
      btnOkColor: Colors.red,
    ).show();
  }

  void _showWelcomeDialog() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.bottomSlide,
          title: "Selamat Datang!",
          desc: "Atur tugas-tugasmu dengan mudah dan tetap produktif!",
          btnOkOnPress: () {},
          btnOkText: "Mulai",
        ).show();
      }
    });
  }

  void _confirmLogout() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "Konfirmasi Logout",
      desc: "Apakah Anda yakin ingin logout?",
      btnCancelOnPress: () {},
      btnCancelText: "Tidak",
      btnOkOnPress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      btnOkText: "Ya, Logout",
      btnOkColor: Colors.red,
    ).show();
  }

  void _showEditDialog(int index) {
    TextEditingController controller = TextEditingController(
      text: notes[index],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Catatan"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Masukkan catatan baru"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _editNote(index, controller.text);
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do List",
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
      body:
          notes.isEmpty
              ? Center(child: Text("Belum ada catatan, tambahkan sekarang!"))
              : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(notes[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          if (newNote != null) {
            _addNote(newNote);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade300,
      ),
    );
  }
}
