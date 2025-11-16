import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../blocs/notes_list_bloc/notes_list_bloc.dart';
import '../blocs/notes_list_bloc/notes_list_event.dart';
import '../models/note.dart';
import '../repositories/notes_repository.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? editingNote;

  const NoteFormScreen({super.key, this.editingNote});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika editing note, load data ke form
    if (widget.editingNote != null) {
      _titleController.text = widget.editingNote!.title;
      _contentController.text = widget.editingNote!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteFormCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.editingNote == null ? 'Buat Catatan Baru' : 'Edit Catatan',
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(onPressed: _saveNote, icon: const Icon(Icons.save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<NoteFormCubit>().updateTitle(value);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Konten',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {
                    context.read<NoteFormCubit>().updateContent(value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final notesRepository = context.read<NotesRepository>();
    final notesListBloc = context.read<NotesListBloc>();

    // Validasi form
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong!')),
      );
      return;
    }

    // Create atau update note
    final noteToSave = widget.editingNote == null
        ? Note(
            id: null,
            title: _titleController.text,
            content: _contentController.text,
            createdAt: DateTime.now(),
          )
        : Note(
            id: widget.editingNote!.id,
            title: _titleController.text,
            content: _contentController.text,
            createdAt: widget.editingNote!.createdAt,
          );

    // Save ke database
    notesRepository
        .saveNote(noteToSave)
        .then((_) {
          // Refresh notes list
          notesListBloc.add(RefreshNotes());
          Navigator.pop(context); // Kembali ke home
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
        });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
