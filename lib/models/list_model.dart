// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListModel {
  int? id;
  final String listtitle;
  final int customcolor;
  final int primarycolor;
  final String emoji;
  ListModel({
    this.id,
    required this.listtitle,
    required this.customcolor,
    required this.primarycolor,
    required this.emoji,
  });
  

  ListModel copyWith({
    int? id,
    String? listtitle,
    int? customcolor,
    int? primarycolor,
    String? emoji,
  }) {
    return ListModel(
      id: id ?? this.id,
      listtitle: listtitle ?? this.listtitle,
      customcolor: customcolor ?? this.customcolor,
      primarycolor: primarycolor ?? this.primarycolor,
      emoji: emoji ?? this.emoji,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'listtitle': listtitle,
      'customcolor': customcolor,
      'primarycolor': primarycolor,
      'emoji': emoji,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'] != null ? map['id'] as int : null,
      listtitle: map['listtitle'] as String,
      customcolor: map['customcolor'] as int,
      primarycolor: map['primarycolor'] as int,
      emoji: map['emoji'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) => ListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListModel(id: $id, listtitle: $listtitle, customcolor: $customcolor, primarycolor: $primarycolor, emoji: $emoji)';
  }

  @override
  bool operator ==(covariant ListModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.listtitle == listtitle &&
      other.customcolor == customcolor &&
      other.primarycolor == primarycolor &&
      other.emoji == emoji;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      listtitle.hashCode ^
      customcolor.hashCode ^
      primarycolor.hashCode ^
      emoji.hashCode;
  }
}
