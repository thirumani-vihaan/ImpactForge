class SubmissionModel {
  final String id;
  final String volunteerName;
  final String avatarUrl;
  final int level;
  final String taskTitle;
  final String timeAgo;
  final String description;

  SubmissionModel({
    required this.id,
    required this.volunteerName,
    required this.avatarUrl,
    required this.level,
    required this.taskTitle,
    required this.timeAgo,
    required this.description,
  });

  // Backward compatibility fields
  String get taskId => id;
  String get volunteerId => volunteerName; // Map to username or name reference in simple logic

  SubmissionModel copyWith({
    String? id,
    String? volunteerName,
    String? avatarUrl,
    int? level,
    String? taskTitle,
    String? timeAgo,
    String? description,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      volunteerName: volunteerName ?? this.volunteerName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      taskTitle: taskTitle ?? this.taskTitle,
      timeAgo: timeAgo ?? this.timeAgo,
      description: description ?? this.description,
    );
  }

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String? ?? '',
      volunteerName: json['volunteerName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      taskTitle: json['taskTitle'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? 'Just now',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volunteerName': volunteerName,
      'avatarUrl': avatarUrl,
      'level': level,
      'taskTitle': taskTitle,
      'timeAgo': timeAgo,
      'description': description,
    };
  }
}
