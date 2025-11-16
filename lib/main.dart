import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/notes_list_bloc/notes_list_bloc.dart';
import 'blocs/notes_list_bloc/notes_list_event.dart';
import 'pages/notes_list_screen.dart';
import 'repositories/notes_repository.dart';

void main() async {
  // Pastikan binding Flutter diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Buka Hive box untuk notes
  await Hive.openBox<Map>('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NotesRepository(Hive.box('notesBox')),
      child: BlocProvider(
        create: (context) =>
            NotesListBloc(context.read<NotesRepository>())..add(LoadNotes()),
        child: MaterialApp(
          title: 'Notes App with BLoC & Hive',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: const NotesListScreen(),
        ),
      ),
    );
  }
}
