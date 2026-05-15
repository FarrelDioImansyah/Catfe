class CatModel {
  final String id;
  final String name;
  final String breed;
  final int age;
  final String description;
  final String imageUrl;
  final String personality; // e.g., 'Friendly', 'Sleepy', 'Playful'
  final bool isAvailable;

  CatModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.description,
    required this.imageUrl,
    required this.personality,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'description': description,
      'imageUrl': imageUrl,
      'personality': personality,
      'isAvailable': isAvailable,
    };
  }

  factory CatModel.fromMap(Map<dynamic, dynamic> map) {
    return CatModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      breed: map['breed']?.toString() ?? '',
      age: map['age'] ?? 0,
      description: map['description']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      personality: map['personality']?.toString() ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  CatModel copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    String? description,
    String? imageUrl,
    String? personality,
    bool? isAvailable,
  }) {
    return CatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      personality: personality ?? this.personality,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
