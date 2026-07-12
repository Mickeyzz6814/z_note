//import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:z_note/models/note_model.dart';
import 'dart:math';

class NoteDb {
  static Box get _box => Hive.box('note_box');

  static Future<String?> addNote({
    required String title,
    required String content,
  }) async {
    String dateId = DateTime.now().millisecondsSinceEpoch.toString();
    String numberId = Random().nextInt(10000).toString().padLeft(4, '0');
    String uniqueId = '$dateId$numberId';
    NoteModel note = NoteModel(
      id: uniqueId,
      title: title,
      content: content,
      createTime: DateTime.now(),
      updateTime: DateTime.now(),
    );
    await _box.put(uniqueId, note);
    return uniqueId;
  }

  static Future<void> editNote({
    required String id,
    required String title,
    required String content,
  }) async {
    NoteModel? oldNote = _box.get(id);
    if (oldNote == null) return;
    NoteModel newNote = oldNote.copyWith(title: title, content: content);
    await _box.put(id, newNote);
  }

  static Future<void> deleteNote({required String id}) async {
    await _box.delete(id);
  }

  static List<NoteModel> getAllNoteList() {
    List<NoteModel> list = _box.values.cast<NoteModel>().toList();
    list.sort((a, b) => b.updateTime.compareTo(a.updateTime));
    return list;
  }

  static NoteModel? getNoteById({required String id}) {
    return _box.get(id);
  }
}
