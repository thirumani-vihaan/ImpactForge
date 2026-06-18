class LeaderboardModel {
  final String name;
  final int rank;
  final String avatarUrl;
  final int points;
  final String badgeText;
  final int tasksCompleted;
  final bool isYou;

  LeaderboardModel({
    required this.name,
    required this.rank,
    required this.avatarUrl,
    required this.points,
    required this.badgeText,
    required this.tasksCompleted,
    required this.isYou,
  });

  LeaderboardModel copyWith({
    String? name,
    int? rank,
    String? avatarUrl,
    int? points,
    String? badgeText,
    int? tasksCompleted,
    bool? isYou,
  }) {
    return LeaderboardModel(
      name: name ?? this.name,
      rank: rank ?? this.rank,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      badgeText: badgeText ?? this.badgeText,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      isYou: isYou ?? this.isYou,
    );
  }

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      name: json['name'] as String? ?? '',
      rank: json['rank'] as int? ?? 1,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      badgeText: json['badgeText'] as String? ?? 'Volunteer',
      tasksCompleted: json['tasksCompleted'] as int? ?? 0,
      isYou: json['isYou'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rank': rank,
      'avatarUrl': avatarUrl,
      'points': points,
      'badgeText': badgeText,
      'tasksCompleted': tasksCompleted,
      'isYou': isYou,
    };
  }
}
