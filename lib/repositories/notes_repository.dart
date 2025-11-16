import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  final Box<Map> notesBox;

  NotesRepository(this.notesBox);

  // Menyimpan note baru
  Future<void> saveNote(Note note) async {
    if (note.id == null) {
      // Note baru - generate ID
      final id = await notesBox.add(note.toMap());
      final newNote = note.copyWith(id: id);
      await notesBox.put(id, newNote.toMap());
    } else {
      // Update note existing
      await notesBox.put(note.id, note.toMap());
    }
  }

  // Mengambil semua note
  List<Note> getAllNotes() {
    final notes = notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .toList();

    // Urutkan dari terbaru ke terlama
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  // Menghapus note berdasarkan ID
  Future<void> deleteNote(int id) async {
    await notesBox.delete(id);
  }

  // Mengambil note by ID
  Note? getNoteById(int id) {
    final map = notesBox.get(id);
    return map != null ? Note.fromMap(Map<String, dynamic>.from(map)) : null;
  }
}
