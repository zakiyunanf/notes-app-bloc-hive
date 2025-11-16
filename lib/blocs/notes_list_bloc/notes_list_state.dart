import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NotesListState extends Equatable {
  const NotesListState();

  @override
  List<Object> get props => [];
}

class NotesListLoading extends NotesListState {}

class NotesListLoaded extends NotesListState {
  final List<Note> notes;

  const NotesListLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NotesListError extends NotesListState {
  final String message;

  const NotesListError(this.message);

  @override
  List<Object> get props => [message];
}
