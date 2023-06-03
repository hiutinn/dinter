import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String name;
  late int age;
  late String gender;
  late String bio;
  late String imageUrl;

  User(this.id, this.name, this.age, this.gender, this.bio, this.imageUrl);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(doc.id, data['name'] ?? '', data['age'] ?? 0,
        data['gender'] ?? '', data['bio'] ?? '', data['imageUrl'] ?? '');
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(map['id'], map['name'], map['age'], map['gender'], map['bio'],
        map['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'bio': bio,
      'imageUrl': imageUrl
    };
  }

  User.empty();
}
