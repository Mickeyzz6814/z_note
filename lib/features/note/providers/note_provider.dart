import 'package:flutter/material.dart';
import 'package:z_note/data/models/note_model.dart';
import 'package:z_note/data/repositories/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  List<NoteModel> _note = [];

  List<NoteModel> get notes => _note;

  void loadNotes() {
    _note = NoteRepository.getAllNoteList();
    //print('Load notes');
    notifyListeners();
  }

  Future<String?> addNote({
    required String title,
    required String content,
  }) async {
    final uniqueId = await NoteRepository.addNote(
      title: title,
      content: content,
    );
    loadNotes();
    return uniqueId;
  }

  Future<void> editNote({
    required String id,
    required String title,
    required String content,
  }) async {
    await NoteRepository.editNote(id: id, title: title, content: content);
    loadNotes();
  }

  Future<void> deleteNote({required String id}) async {
    await NoteRepository.deleteNote(id: id);
    loadNotes();
  }

  List<NoteModel> getAllNoteList() {
    return NoteRepository.getAllNoteList();
  }

  NoteModel? getNoteById({required String id}) {
    loadNotes();
    return NoteRepository.getNoteById(id: id);
  }
}
