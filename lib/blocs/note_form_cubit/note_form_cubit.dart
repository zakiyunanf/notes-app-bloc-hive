import 'package:bloc/bloc.dart';
import '../../models/note.dart';

class NoteFormCubit extends Cubit<Note> {
  NoteFormCubit() : super(Note(
    id: null,
    title: '', 
    content: '', 
    createdAt: DateTime.now(),
  ));

  void updateTitle(String title) {
    final current = state;
    emit(current.copyWith(title: title));
  }

  void updateContent(String content) {
    final current = state;
    emit(current.copyWith(content: content));
  }

  void reset() {
    emit(Note(
      id: null,
      title: '', 
      content: '', 
      createdAt: DateTime.now(),
    ));
  }

  void loadNote(Note note) {
    emit(note);
  }

  bool isValid() {
    return state.title.trim().isNotEmpty;
  }
}