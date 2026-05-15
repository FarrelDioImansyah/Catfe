import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/cat_model.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/app_image.dart';

class AdminAddCatScreen extends StatefulWidget {
  final CatModel? cat;
  const AdminAddCatScreen({super.key, this.cat});

  @override
  State<AdminAddCatScreen> createState() => _AdminAddCatScreenState();
}

class _AdminAddCatScreenState extends State<AdminAddCatScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descController;
  late TextEditingController _personalityController;
  bool _isAvailable = true;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cat?.name);
    _breedController = TextEditingController(text: widget.cat?.breed);
    _ageController = TextEditingController(text: widget.cat?.age.toString());
    _descController = TextEditingController(text: widget.cat?.description);
    _personalityController = TextEditingController(text: widget.cat?.personality);
    if (widget.cat != null) {
      _isAvailable = widget.cat!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descController.dispose();
    _personalityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final admin = Provider.of<AdminProvider>(context, listen: false);
      
      final cat = CatModel(
        id: widget.cat?.id ?? '',
        name: _nameController.text.trim(),
        breed: _breedController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        description: _descController.text.trim(),
        personality: _personalityController.text.trim(),
        imageUrl: widget.cat?.imageUrl ?? '',
        isAvailable: _isAvailable,
      );

      await admin.saveCat(cat, _imageFile);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.cat == null ? 'Add Cat Profile' : 'Edit Cat Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : AppImage(
                            imageUrl: widget.cat?.imageUrl ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(controller: _nameController, label: 'Cat Name', icon: Icons.pets, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _breedController, label: 'Breed', icon: Icons.category, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _ageController, label: 'Age', icon: Icons.calendar_today, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _personalityController, label: 'Personality (e.g. Friendly)', icon: Icons.emoji_emotions, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _descController, label: 'Description', icon: Icons.description, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available in Café'),
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: admin.isLoading ? null : _save,
                  child: admin.isLoading ? const CircularProgressIndicator() : const Text('Save Cat Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
