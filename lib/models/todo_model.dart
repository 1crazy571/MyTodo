import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ToDoModel {
  int? id;
  final String title;
  final String text;
  final String createdAt;
  final String schedule;
  final String isimportant;
  final String istoday;
  final String isdone;
  final String? tablename;
  ToDoModel({
    this.id,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.schedule,
    required this.isimportant,
    required this.istoday,
    required this.isdone,
    this.tablename,
  });

  ToDoModel copyWith({
    int? id,
    String? title,
    String? text,
    String? createdAt,
    String? schedule,
    String? isimportant,
    String? istoday,
    String? isdone,
    String? tablename,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      schedule: schedule ?? this.schedule,
      isimportant: isimportant ?? this.isimportant,
      istoday: istoday ?? this.istoday,
      isdone: isdone ?? this.isdone,
      tablename: tablename ?? this.tablename,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'text': text,
      'createdAt': createdAt,
      'schedule': schedule,
      'isimportant': isimportant,
      'istoday': istoday,
      'isdone': isdone,
      'tablename': tablename,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      schedule: map['schedule'] as String,
      isimportant: map['isimportant'] as String,
      istoday: map['istoday'] as String,
      isdone: map['isdone'] as String,
      tablename: map['tablename'] != null ? map['tablename'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDoModel.fromJson(String source) =>
      ToDoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ToDoModel(id: $id, title: $title, text: $text, createdAt: $createdAt, schedule: $schedule, isimportant: $isimportant, istoday: $istoday, isdone: $isdone, tablename: $tablename)';
  }

  @override
  bool operator ==(covariant ToDoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.schedule == schedule &&
        other.isimportant == isimportant &&
        other.istoday == istoday &&
        other.isdone == isdone &&
        other.tablename == tablename;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        schedule.hashCode ^
        isimportant.hashCode ^
        istoday.hashCode ^
        isdone.hashCode ^
        tablename.hashCode;
  }
}
