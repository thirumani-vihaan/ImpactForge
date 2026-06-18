class UserModel {
  final String email;
  final String name;
  final String role; // 'volunteer' or 'admin'
  final int points;
  final int level;
  final int tasksCompletedCount;
  final int timeDonatedHours;
  final String bio;
  final String avatarUrl;

  UserModel({
    required this.email,
    required this.name,
    required this.role,
    required this.points,
    required this.level,
    required this.tasksCompletedCount,
    required this.timeDonatedHours,
    required this.bio,
    required this.avatarUrl,
  });

  // Alias for backward compatibility if other places referenced `karmaPoints` or `id`
  String get id => email;
  int get karmaPoints => points;
  int get livesTouched => tasksCompletedCount * 12; // Derived or fallback value

  UserModel copyWith({
    String? email,
    String? name,
    String? role,
    int? points,
    int? level,
    int? tasksCompletedCount,
    int? timeDonatedHours,
    String? bio,
    String? avatarUrl,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      points: points ?? this.points,
      level: level ?? this.level,
      tasksCompletedCount: tasksCompletedCount ?? this.tasksCompletedCount,
      timeDonatedHours: timeDonatedHours ?? this.timeDonatedHours,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'volunteer',
      points: json['points'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      tasksCompletedCount: json['tasksCompletedCount'] as int? ?? 0,
      timeDonatedHours: json['timeDonatedHours'] as int? ?? 0,
      bio: json['bio'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'points': points,
      'level': level,
      'tasksCompletedCount': tasksCompletedCount,
      'timeDonatedHours': timeDonatedHours,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }
}
