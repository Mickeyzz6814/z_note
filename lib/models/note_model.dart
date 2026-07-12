import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createTime;

  @HiveField(4)
  DateTime updateTime;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createTime,
    required this.updateTime,
  });

  NoteModel copyWith({String? title, String? content, DateTime? updateTime}) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createTime: DateTime.now(),
      updateTime: updateTime ?? DateTime.now(),
    );
  }
}
