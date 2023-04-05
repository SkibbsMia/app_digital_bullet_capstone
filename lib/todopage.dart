import 'package:digital_bullet/database/sql_todo_helper.dart';
import 'package:flutter/material.dart';
import 'package:digital_bullet/tabbar.dart';
import 'package:intl/intl.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<Map<String, dynamic>> _tasks = [];

  void _refreshTasks() async {
    final data = await SQLToDoHelper.getItems();
    setState(() {
      _tasks = data;
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateInput = TextEditingController();

  Future<void> _addItem() async {
    await SQLToDoHelper.createItem(
        _titleController.text, _descriptionController.text, _dateInput.text);
    _refreshTasks();
  }

  Future<void> _updateItemStatus(int id, int completed) async {
    if (completed == 1) {
      completed = 0;
    } else if (completed == 0) {
      completed = 1;
    }

    await SQLToDoHelper.isCompleted(id, completed);
    _refreshTasks();
  }

  Future<void> _updateItem(int id) async {
    await SQLToDoHelper.updateItem(id, _titleController.text,
        _descriptionController.text, _dateInput.text);
    _refreshTasks();
  }

  Future<void> _deleteItem(int id) async {
    final navigator = ScaffoldMessenger.of(context);
    await SQLToDoHelper.deleteItem(id);
    navigator.showSnackBar(const SnackBar(
      content: Text('Successfully deleted a Task!'),
    ));
    _refreshTasks();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingTasks = _tasks.firstWhere((element) => element['id'] == id);
      _titleController.text = existingTasks['title'];
      _descriptionController.text = existingTasks['description'];
      _dateInput.text = existingTasks['dueDate'];
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
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Row(children: [
                  TextField(
                    controller: _dateInput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        //icon of text field
                        labelText: "Enter Due Date" //label text of field
                        ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 9,
                              DateTime.now().month, DateTime.now().day));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dateInput.text = formattedDate;
                        });
                      } else {}
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          if (id == null) {
                            await _addItem();
                          }
                          if (id != null) {
                            await _updateItem(id);
                          }
                          _titleController.text = '';
                          _descriptionController.text = '';
                          _dateInput.text = '';

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
                                await _deleteItem(id);
                              }
                              navigator.pop();
                            },
                            icon: const Icon(Icons.delete, size: 20)),
                      )
                    ],
                  )
                ])
            //],
            //),
            ));
  }

  @override
  void initState() {
    super.initState();
    _refreshTasks();
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
                "To Do List",
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
                padding: const EdgeInsets.fromLTRB(15, 63, 10, 33),
                width: 350,
                height: 750,
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) => Card(
                    color: const Color(0xFFE9E2D8),
                    child: ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
                        value: _tasks[index]['completed'] == 1 ? false : true,
                        onChanged: (bool? value) {
                          _updateItemStatus(
                              _tasks[index]['id'], _tasks[index]['completed']);
                        },
                      ),
                      title: Text(_tasks[index]['title']),
                      subtitle: Column(
                        children: [
                          Text(_tasks[index]['description']),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Due: ${_tasks[index]['dueDate'].toString()}'),
                        ],
                      ),
                      trailing: SizedBox(
                          width: 48,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      _showForm(_tasks[index]['id']),
                                  icon: const Icon(Icons.edit, size: 20)),
                            ],
                          )),
                    ),
                  ),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(260, 15, 0, 0),
                child: IconButton(
                    iconSize: 40,
                    color: Colors.black,
                    onPressed: () => _showForm(null),
                    icon: const Icon(Icons.add_circle)))
          ],
        ));
  }

  Image backgroundWidget(BuildContext context) {
    return Image.asset(
      'lib/assets/DotBackground.png',
      width: MediaQuery.of(context).size.width * 1.2,
      height: MediaQuery.of(context).size.height * 1,
      fit: BoxFit.fitHeight,
    );
  }
}
