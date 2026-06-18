class ActiveTaskModel {
  final String id;
  final String userEmail;
  final String title;
  final String description;
  final String dueText;
  final String status;
  final String type;

  ActiveTaskModel({
    required this.id,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.dueText,
    required this.status,
    required this.type,
  });

  ActiveTaskModel copyWith({
    String? id,
    String? userEmail,
    String? title,
    String? description,
    String? dueText,
    String? status,
    String? type,
  }) {
    return ActiveTaskModel(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      title: title ?? this.title,
      description: description ?? this.description,
      dueText: dueText ?? this.dueText,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  factory ActiveTaskModel.fromJson(Map<String, dynamic> json) {
    return ActiveTaskModel(
      id: json['id'] as String? ?? '',
      userEmail: (json['userEmail'] ?? json['user_email']) as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueText: json['dueText'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      type: json['type'] as String? ?? 'report',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'title': title,
      'description': description,
      'dueText': dueText,
      'status': status,
      'type': type,
    };
  }
}
