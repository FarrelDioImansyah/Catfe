import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class StorageService {
  // TODO: Ganti dengan API Key ImgBB Anda sendiri (kunjungi https://api.imgbb.com/)
  final String _apiKey = '61aea39d47a3a6482776b3b76850ea7b';

  // Upload gambar ke ImgBB secara gratis dan dapatkan URL publik
  Future<String?> uploadImage(File image, String folder) async {
    // Jika API Key belum dikonfigurasi, beritahu pengembang
    if (_apiKey.isEmpty || _apiKey == 'API_KEY_IMGBB_ANDA') {
      print('PERINGATAN: API Key ImgBB belum dikonfigurasi! Gambar tidak dapat di-upload.');
      return null;
    }

    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan file gambar ke request
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final imageUrl = responseData['data']['url'] as String;
        print('Upload berhasil! URL Gambar: $imageUrl');
        return imageUrl;
      } else {
        print('Gagal upload ke ImgBB: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error mengunggah gambar ke ImgBB: $e');
      return null;
    }
  }

  // ImgBB gratis tidak mendukung hapus jarak jauh langsung via URL dari client secara sederhana,
  // sehingga kita bypass agar tidak merusak fungsionalitas
  Future<void> deleteImage(String imageUrl) async {
    print('Penghapusan gambar di ImgBB di-bypass untuk keamanan.');
  }
}

