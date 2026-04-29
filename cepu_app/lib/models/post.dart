import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String? image;
  String? description;
  String? category;
  double? latitude;
  double? longitude;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? userId;
  String? userFullName;

  Post({
    this.id,
    this.image,
    this.description,
    this.category,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.userFullName,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      image: data['image'] as String?,
      description: data['description'] as String?,
      category: data['category'] as String?,
      latitude: data['latitude'] != null
          ? (data['latitude'] is num
              ? (data['latitude'] as num).toDouble()
              : double.tryParse(data['latitude'].toString()))
          : null,
      longitude: data['longitude'] != null
          ? (data['longitude'] is num
              ? (data['longitude'] as num).toDouble()
              : double.tryParse(data['longitude'].toString()))
          : null,
      createdAt:
          data['created_at'] is Timestamp ? data['created_at'] as Timestamp : null,
      updatedAt:
          data['updated_at'] is Timestamp ? data['updated_at'] as Timestamp : null,
      userId: data['user_id'] as String?,
      userFullName: data['user_full_name'] as String?,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'image': image,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'user_full_name': userFullName,
    };
  }
}