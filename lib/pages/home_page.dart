import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _showWelcomeDialog();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _confirmLogout,
          ),
        ],
        backgroundColor: Colors.blue.shade300,
        elevation: 4, // Memberikan efek bayangan
      ),
      body: Center(
        child: Card(
          elevation: 6, // Memberikan efek bayangan pada kartu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, size: 80, color: Colors.blue.shade300),
                SizedBox(height: 16),
                Text(
                  "Atur tugas-tugasmu dengan mudah dan tetap produktif!",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Nanti bisa diarahkan ke halaman daftar tugas
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Mulai", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
