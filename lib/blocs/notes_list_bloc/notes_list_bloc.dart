import 'package:bloc/bloc.dart';
import '../../repositories/notes_repository.dart';
import 'notes_list_event.dart';
import 'notes_list_state.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final NotesRepository notesRepository;

  NotesListBloc(this.notesRepository) : super(NotesListLoading()) {
    on<LoadNotes>((event, emit) {
      try {
        final notes = notesRepository.getAllNotes();
        emit(NotesListLoaded(notes));
      } catch (e) {
        emit(NotesListError('Gagal memuat notes: $e'));
      }
    });

    on<DeleteNote>((event, emit) {
      try {
        notesRepository.deleteNote(event.noteId);
        final notes = notesRepository.getAllNotes();
        emit(NotesListLoaded(notes));
      } catch (e) {
        emit(NotesListError('Gagal menghapus note: $e'));
      }
    });

    on<RefreshNotes>((event, emit) {
      try {
        final notes = notesRepository.getAllNotes();
        emit(NotesListLoaded(notes));
      } catch (e) {
        emit(NotesListError('Gagal refresh notes: $e'));
      }
    });
  }
}
