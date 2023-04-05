/*
Description: This page is dedicated for habit tracking, it could be from doing a
workout everyday (or even just 4 or 5 times a week) to simply brushing your
teeth before you go to bed.
*/

import 'package:digital_bullet/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'database/sql_habits_helper.dart';
import 'package:sleek_button/sleek_button.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({Key? key}) : super(key: key);

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  // the map that holds all of the highlighted days (days that you have accomplished)
  Map<DateTime, int> _habitCalendar = {};

  // the list of habits that this user holds
  List<Map<String, dynamic>> _habits = [];

  // the current habit it is on in the application
  int currentHabit = 0;

  // the text editors for inputting and editing habits
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This allows the page to refresh, this is used either for adding or editing
  // a habit or for loading the page initially
  void _refreshHabitCalendar() async {
    // we first start by grabbing all of the habit's data that the user has
    final habitData = await SQLHabitsHelper.getHabits();
    setState(() {
      _habits = habitData;
    });

    // then we go and grab the current habits information, what days have been
    // done in the calendar
    if (_habits.isNotEmpty) {
      final data = await SQLHabitsHelper.getHabitCalendar(
          _habits[currentHabit]['habit_id']);
      setState(() {
        _habitCalendar = {};
        for (var i = 0; i < data.length; i++) {
          DateTime date = DateTime.parse(data[i]['date']);
          _habitCalendar.addAll({date: data[i]['completed']});
        }
      });
    }
  }

  // a function that deletes a specific day from the database, this will stop
  // the date from being highlighted and will
  Future<void> _deleteHabitCalendar(int id, String date) async {
    await SQLHabitsHelper.deleteHabitCalendar(id, date);
    _refreshHabitCalendar();
  }

  // this deleted the habit entirely, so there will be no more information about
  // that habit anymore in the database
  Future<void> _deleteHabit(int id) async {
    await SQLHabitsHelper.deleteHabit(id);

    // if the current habit that is being deleted is the first habit in the list
    // do nothing, otherwise subtract 1 so that there won't be any index errors
    currentHabit = currentHabit != 0 ? currentHabit-- : 0;
    _refreshHabitCalendar();
  }

  // function that allows the user to add a habit to their application
  Future<void> _addHabit() async {
    await SQLHabitsHelper.createHabit(
        _nameController.text, _descriptionController.text);
    _refreshHabitCalendar();
  }

  // function that allows the user to edit their habits that they have already
  // created.
  Future<void> _updateHabit(id) async {
    await SQLHabitsHelper.updateHabit(
        id, _nameController.text, _descriptionController.text);
    _refreshHabitCalendar();
  }

  // function that adds a date that will be highlighted (user completed task
  // for the day)
  Future<void> _addToHabitCalendar(String date, int id, int completed) async {
    await SQLHabitsHelper.createHabitCalendar(date, id, completed);
    _refreshHabitCalendar();
  }

  // opens up a bottom bar for the user to be able to add or edit habits
  void _showForm(int? id) async {
    // If the id is not null, that means the user is editing a previously
    // entered habit
    if (id != null) {
      final existingTasks =
          _habits.firstWhere((element) => element['habit_id'] == id);
      _nameController.text = existingTasks['name'];
      _descriptionController.text = existingTasks['description'];
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
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SleekButton(
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          if (id == null) {
                            await _addHabit();
                          }
                          if (id != null) {
                            await _updateHabit(id);
                          }
                          _nameController.text = '';
                          _descriptionController.text = '';

                          navigator.pop();
                        },
                        style: SleekButtonStyle.flat(
                          color: Colors.brown,
                          inverted: false,
                          rounded: true,
                          size: SleekButtonSize.medium,
                          context: context,
                        ),
                        child: Text(id == null ? 'Create New' : 'Update'),
                      ),
                      Visibility(
                        visible: (id == null ? false : true),
                        child: IconButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              if (id != null) {
                                await _deleteHabit(
                                    _habits[currentHabit]['habit_id']);
                                currentHabit = 0;
                              }

                              _nameController.text = '';
                              _descriptionController.text = '';
                              navigator.pop();
                            },
                            icon: const Icon(Icons.delete, size: 20)),
                      )
                    ],
                  )
                ]))).whenComplete(() {
      _nameController.text = '';
      _descriptionController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshHabitCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                "Habits",
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
                padding: const EdgeInsets.fromLTRB(15, 50, 10, 0),
                width: 350,
                height: 750,
                child: Column(children: [
                  HeatMapCalendar(
                    weekTextColor: Colors.black,
                    showColorTip: false,
                    textColor: Colors.black38,
                    defaultColor: const Color(0xFFE9E2D8),
                    flexible: true,
                    colorMode: ColorMode.color,
                    datasets: _habitCalendar,
                    colorsets: const {
                      1: Colors.pink,
                    },
                    onClick: (value) {
                      setState(() {
                        if (_habits.isNotEmpty) {
                          if (_habitCalendar[value] == 1) {
                            _deleteHabitCalendar(
                                _habits[currentHabit]['habit_id'],
                                value.toString());
                          } else {
                            _addToHabitCalendar(value.toString(),
                                _habits[currentHabit]['habit_id'], 1);
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (currentHabit > 0) {
                              setState(() {
                                currentHabit--;
                                _refreshHabitCalendar();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            size: 60,
                            color: _habits.isEmpty
                                ? Colors.white24
                                : (currentHabit == 0
                                    ? Colors.white24
                                    : Colors.black),
                          )),
                      const SizedBox(
                        width: 200,
                      ),
                      IconButton(
                          onPressed: () {
                            if (currentHabit < _habits.length - 1) {
                              setState(() {
                                currentHabit++;
                                _refreshHabitCalendar();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            size: 60,
                            color: _habits.isEmpty
                                ? Colors.white24
                                : (currentHabit == _habits.length - 1
                                    ? Colors.white24
                                    : Colors.black),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _habits.isNotEmpty
                        ? _habits[currentHabit]['name']
                        : 'Please Add A Habit',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_habits.isNotEmpty
                      ? _habits[currentHabit]['description']
                      : ''),
                  const SizedBox(
                    height: 20,
                  ),
                  SleekButton(
                      onTap: () async {
                        _showForm(null);
                      },
                      style: SleekButtonStyle.flat(
                        color: Colors.brown,
                        inverted: false,
                        rounded: true,
                        size: SleekButtonSize.medium,
                        context: context,
                      ),
                      child: const Text('Add New Habit')),
                  const SizedBox(
                    height: 10,
                  ),
                  SleekButton(
                      onTap: () async {
                        _showForm(_habits[currentHabit]['habit_id']);
                      },
                      style: SleekButtonStyle.flat(
                        color: Colors.brown,
                        inverted: false,
                        rounded: true,
                        size: SleekButtonSize.medium,
                        context: context,
                      ),
                      child: const Text('Edit Habit')),
                ])),
          ],
        ));
  }
}
