import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String deadlineText;
  final String location;
  final int volunteersCount;
  final int points;
  final int peopleEmpowered;
  final String extendedDescription;
  final List<dynamic> instructions; // JSONB Array
  final List<dynamic> resources;    // JSONB Array

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.deadlineText,
    required this.location,
    required this.volunteersCount,
    required this.points,
    required this.peopleEmpowered,
    required this.extendedDescription,
    required this.instructions,
    required this.resources,
  });

  // Backward compatibility properties
  String get deadline => deadlineText;
  bool get hasAvatars => volunteersCount > 0;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? deadlineText,
    String? location,
    int? volunteersCount,
    int? points,
    int? peopleEmpowered,
    String? extendedDescription,
    List<dynamic>? instructions,
    List<dynamic>? resources,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      deadlineText: deadlineText ?? this.deadlineText,
      location: location ?? this.location,
      volunteersCount: volunteersCount ?? this.volunteersCount,
      points: points ?? this.points,
      peopleEmpowered: peopleEmpowered ?? this.peopleEmpowered,
      extendedDescription: extendedDescription ?? this.extendedDescription,
      instructions: instructions ?? this.instructions,
      resources: resources ?? this.resources,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Helper to decode potential stringified JSON from postgrest responses
    List<dynamic> parseJsonList(dynamic field) {
      if (field == null) return [];
      if (field is List) return field;
      if (field is String) {
        try {
          return jsonDecode(field) as List;
        } catch (_) {}
      }
      return [];
    }

    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      deadlineText: json['deadlineText'] as String? ?? '',
      location: json['location'] as String? ?? '',
      volunteersCount: json['volunteersCount'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      peopleEmpowered: json['peopleEmpowered'] as int? ?? 0,
      extendedDescription: json['extendedDescription'] as String? ?? '',
      instructions: parseJsonList(json['instructions']),
      resources: parseJsonList(json['resources']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'deadlineText': deadlineText,
      'location': location,
      'volunteersCount': volunteersCount,
      'points': points,
      'peopleEmpowered': peopleEmpowered,
      'extendedDescription': extendedDescription,
      'instructions': instructions,
      'resources': resources,
    };
  }
}
