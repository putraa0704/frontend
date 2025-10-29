import 'package:flutter/material.dart';
import 'package:lapor_pak_app/models/aduan.dart';

class AduanDetailScreen extends StatelessWidget {
  final Aduan aduan;

  const AduanDetailScreen({Key? key, required this.aduan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Aduan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(aduan.judul, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
           Text('Tanggal: ${aduan.createdAt}'),
            SizedBox(height: 16),
            Text(aduan.deskripsi),
            SizedBox(height: 16),
            Text('Status: ${aduan.status}'),
          ],
        ),
      ),
    );
  }
}
