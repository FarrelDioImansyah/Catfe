import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageService {
  // Save an image to the local app directory and return the path
  Future<String?> uploadImage(File image, String folder) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final folderDir = Directory('${appDir.path}/$folder');
      
      if (!await folderDir.exists()) {
        await folderDir.create(recursive: true);
      }

      String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final savedImage = await image.copy('${folderDir.path}/$fileName');
      
      return savedImage.path;
    } catch (e) {
      print('Error saving local image: $e');
      return null;
    }
  }

  // Delete a local image
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting local image: $e');
    }
  }
}
