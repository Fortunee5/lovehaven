// lib/models/content_model.dart
class ContentItem {
  final String id;
  final String type; // 'image', 'video', 'text', 'sermon', 'event', 'staff'
  final String title;
  final String? description;
  final String? content;
  final String? mediaUrl;
  final DateTime? date;
  final Map<String, dynamic>? metadata;

  ContentItem({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.content,
    this.mediaUrl,
    this.date,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'content': content,
    'mediaUrl': mediaUrl,
    'date': date?.toIso8601String(),
    'metadata': metadata,
  };

  factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    description: json['description'],
    content: json['content'],
    mediaUrl: json['mediaUrl'],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    metadata: json['metadata'],
  );
}