import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/product_model.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/app_image.dart';

class AdminAddProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AdminAddProductScreen({super.key, this.product});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  String _selectedCategory = 'Coffee';
  bool _isBestSeller = false;
  bool _isPromo = false;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _descController = TextEditingController(text: widget.product?.description);
    _priceController = TextEditingController(text: widget.product?.price.toString());
    if (widget.product != null) {
      _selectedCategory = widget.product!.category;
      _isBestSeller = widget.product!.isBestSeller;
      _isPromo = widget.product!.isPromo;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
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
      
      final product = ProductModel(
        id: widget.product?.id ?? '',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        imageUrl: widget.product?.imageUrl ?? '',
        isBestSeller: _isBestSeller,
        isPromo: _isPromo,
      );

      await admin.saveProduct(product, _imageFile);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
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
                            imageUrl: widget.product?.imageUrl ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(controller: _nameController, label: 'Product Name', icon: Icons.coffee, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _descController, label: 'Description', icon: Icons.description, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _priceController, label: 'Price', icon: Icons.attach_money, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                items: ['Coffee', 'Tea', 'Snack', 'Pastry'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Best Seller'),
                value: _isBestSeller,
                onChanged: (v) => setState(() => _isBestSeller = v),
              ),
              SwitchListTile(
                title: const Text('On Promo'),
                value: _isPromo,
                onChanged: (v) => setState(() => _isPromo = v),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: admin.isLoading ? null : _save,
                  child: admin.isLoading ? const CircularProgressIndicator() : const Text('Save Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
