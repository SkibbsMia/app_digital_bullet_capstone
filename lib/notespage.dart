import 'package:digital_bullet/database/sql_notes_helper.dart';
import 'package:digital_bullet/tabbar.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> _notes = [];

  // the text editors for inputting and editing habits
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _refreshNotes() async {
    // we first start by grabbing all of the notes data that the user has
    final habitData = await SQLNotesHelper.getNotes();
    setState(() {
      _notes = habitData;
    });
  }

  Future<void> _deleteNote(int id) async {
    await SQLNotesHelper.deleteNote(id);
    _refreshNotes();
  }

  Future<void> _addNote() async {
    await SQLNotesHelper.createNote(
        _titleController.text, _noteController.text);
    _refreshNotes();
  }

  Future<void> _updateNote(id) async {
    await SQLNotesHelper.updateNote(
        id, _titleController.text, _noteController.text);
    _refreshNotes();
  }

  void _showForm(int? id, int index) async {
    // If the id is not null, that means the user is editing a previously
    // entered habit
    if (id != null) {
      final existingTasks = _notes.firstWhere((element) => element['id'] == id);
      _noteController.text = existingTasks['note'];
      _titleController.text = existingTasks['title'];
    }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(hintText: 'Note'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          if (id == null) {
                            await _addNote();
                          }
                          if (id != null) {
                            await _updateNote(id);
                          }
                          _titleController.text = '';
                          _noteController.text = '';

                          navigator.pop();
                        },
                        child: Text(id == null ? 'Create New' : 'Update'),
                      ),
                      Visibility(
                        visible: (id == null ? false : true),
                        child: IconButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              if (id != null) {
                                await _deleteNote(_notes[index]['id']);
                              }

                              _titleController.text = '';
                              _noteController.text = '';
                              navigator.pop();
                            },
                            icon: const Icon(Icons.delete, size: 20)),
                      )
                    ],
                  )
                ]))).whenComplete(() {
      _titleController.text = '';
      _noteController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E2D8),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          children: [
            contentWidget(context),
          ],
        ),
      ),
    );
  }

  SizedBox contentWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1.35,
      height: MediaQuery.of(context).size.height * 1,
      child: Stack(children: [
        backgroundWidget(context),
        mainBodyWidget(),
        const TabBarSection(),
      ]),
    );
  }

  Image backgroundWidget(BuildContext context) {
    return Image.asset(
      'lib/assets/DotBackground.png',
      width: MediaQuery.of(context).size.width * 1.2,
      height: MediaQuery.of(context).size.height * 1,
      fit: BoxFit.fitHeight,
    );
  }

  Align mainBodyWidget() {
    return Align(
      alignment: Alignment.topLeft,
      child: Stack(
        children: [
          Image.asset(
            'lib/assets/BrownStickyNote.png',
            width: 350,
            height: 750,
            fit: BoxFit.fill,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(50, 10, 0, 0),
            child: const Text(
              "Notes",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'OpenDyslexic2',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(260, 15, 0, 0),
              child: IconButton(
                  iconSize: 40,
                  color: Colors.black,
                  onPressed: () async {
                    _showForm(null, -1);
                  },
                  icon: const Icon(Icons.add_circle))),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 70, 220, 120),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _showForm(_notes[index]['id'], index);
                    },
                      child: Card(
                    color: Colors.brown,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Stack(children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(50, 10, 0, 0),
                          child: Text(_notes[index]['title']),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(50, 40, 0, 0),
                          child: Text(_notes[index]['note']),
                        ),
                      ]),
                    ),
                  ));
                }),
          ),
        ],
      ),
    );
  }
}
