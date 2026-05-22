import 'package:fleather/fleather.dart';

class Note {
  final String id;
  final String title;
  final Delta content;
  final bool isLocked;
  final String mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    this.id = "",
    required this.title,
    required this.content,
    this.isLocked = false,
    this.mood = "",
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> jsonNote) {
    return Note(
      id: jsonNote['id'],
      title: jsonNote['title'],
      content: Delta.fromJson(jsonNote['content']),
      isLocked: jsonNote['isLocked'] ?? false,
      mood: jsonNote['mood'] ?? "",
      createdAt: DateTime.parse(jsonNote['createdAt']),
      updatedAt: DateTime.parse(jsonNote['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content.toJson().map((e) => e.toJson()).toList(),
      'isLocked': isLocked,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    Delta? content,
    bool? isLocked,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isLocked: isLocked ?? this.isLocked,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
