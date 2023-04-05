import 'dart:async';
import 'package:digital_bullet/database/sql_goals_helper.dart';
import 'package:digital_bullet/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sleek_button/sleek_button.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  double percent = 0.0;
  late Timer _timer;

  // the list of habits that this user holds
  List<Map<String, dynamic>> _goals = [];

  // the current habit it is on in the application
  int currentGoal = 0;

  // the text editors for inputting and editing habits
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This allows the page to refresh, this is used either for adding or editing
  // a habit or for loading the page initially
  void _refreshGoals() async {
    // we first start by grabbing all of the habit's data that the user has
    final data = await SQLGoalsHelper.getGoals();
    setState(() {
      _goals = data;

      if (_goals.isNotEmpty) {
        percent = ((_goals[currentGoal]['percentage']) / 100).toDouble();
      }
    });
  }

  // this deleted the habit entirely, so there will be no more information about
  // that habit anymore in the database
  Future<void> _deleteGoal(int id) async {
    await SQLGoalsHelper.deleteGoal(id);

    // if the current habit that is being deleted is the first habit in the list
    // do nothing, otherwise subtract 1 so that there won't be any index errors
    currentGoal = currentGoal != 0 ? currentGoal-- : 0;
    _refreshGoals();
  }

  // function that allows the user to add a habit to their application
  Future<void> _addGoal() async {
    await SQLGoalsHelper.createGoal(_nameController.text,
        _descriptionController.text, (percent * 100).round());
    _refreshGoals();
  }

  // function that allows the user to edit their habits that they have already
  // created.
  Future<void> _updateGoal(id) async {
    await SQLGoalsHelper.updateGoal(id, _nameController.text,
        _descriptionController.text, (percent * 100).round());
    _refreshGoals();
  }

  Future<void> _updatePercentage(id) async {
    await SQLGoalsHelper.updatePercentage(id, (percent * 100).round());
    _refreshGoals();
  }

  // opens up a bottom bar for the user to be able to add or edit habits
  void _showForm(int? id) async {
    // If the id is not null, that means the user is editing a previously
    // entered habit
    if (id != null) {
      final existingTasks = _goals.firstWhere((element) => element['id'] == id);
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
                            await _addGoal();
                          }
                          if (id != null) {
                            await _updateGoal(id);
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
                                await _deleteGoal(_goals[currentGoal]['id']);
                                currentGoal = 0;
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
    _refreshGoals();
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
                "Goals",
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
                padding: const EdgeInsets.fromLTRB(15, 70, 10, 0),
                width: 350,
                height: 750,
                child: Column(children: [
                  CircularPercentIndicator(
                    animateFromLastPercent: true,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: percent,
                    center: Text((percent * 100).round().toString()),
                    progressColor: Colors.green,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: IconButton(
                            onPressed: () {
                              if (percent != 0.0) {
                                setState(() {
                                  percent -= 0.01;
                                  percent =
                                      double.parse(percent.toStringAsFixed(2));
                                });
                                _updatePercentage(_goals[currentGoal]['id']);
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              size: 40,
                            )),
                        onTapDown: (_) {
                          _timer = Timer.periodic(
                              const Duration(milliseconds: 100), (t) {
                            if (percent != 0.0) {
                              setState(() {
                                percent -= 0.01;
                                percent =
                                    double.parse(percent.toStringAsFixed(2));
                              });
                            }
                          });
                        },
                        onTapUp: (_) {
                          _timer.cancel();
                          _updatePercentage(_goals[currentGoal]['id']);
                        },
                        onTapCancel: () {
                          _timer.cancel();
                          _updatePercentage(_goals[currentGoal]['id']);
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        child: IconButton(
                            onPressed: () {
                              if (percent != 1.0) {
                                setState(() {
                                  percent += 0.01;
                                  percent =
                                      double.parse(percent.toStringAsFixed(2));
                                });
                                _updatePercentage(_goals[currentGoal]['id']);
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 40,
                            )),
                        onTapDown: (_) {
                          _timer = Timer.periodic(
                              const Duration(milliseconds: 100), (t) {
                            if (percent != 1.0) {
                              setState(() {
                                percent += 0.01;
                                percent =
                                    double.parse(percent.toStringAsFixed(2));
                              });
                            }
                          });
                        },
                        onTapUp: (_) {
                          _timer.cancel();
                          _updatePercentage(_goals[currentGoal]['id']);
                        },
                        onTapCancel: () {
                          _timer.cancel();
                          _updatePercentage(_goals[currentGoal]['id']);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (currentGoal > 0) {
                              setState(() {
                                currentGoal--;
                                _refreshGoals();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            size: 60,
                            color: _goals.isEmpty
                                ? Colors.white24
                                : (currentGoal == 0
                                    ? Colors.white24
                                    : Colors.black),
                          )),
                      const SizedBox(
                        width: 200,
                      ),
                      IconButton(
                          onPressed: () {
                            if (currentGoal < _goals.length - 1) {
                              setState(() {
                                currentGoal++;
                                _refreshGoals();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            size: 60,
                            color: _goals.isEmpty
                                ? Colors.white24
                                : (currentGoal == _goals.length - 1
                                    ? Colors.white24
                                    : Colors.black),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _goals.isNotEmpty
                        ? _goals[currentGoal]['name']
                        : 'Please Add A Goal',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(_goals.isNotEmpty
                      ? _goals[currentGoal]['description']
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
                      child: const Text('Add New Goal')),
                  const SizedBox(
                    height: 10,
                  ),
                  SleekButton(
                      onTap: () async {
                        _showForm(_goals[currentGoal]['id']);
                      },
                      style: SleekButtonStyle.flat(
                        color: Colors.brown,
                        inverted: false,
                        rounded: true,
                        size: SleekButtonSize.medium,
                        context: context,
                      ),
                      child: const Text('Edit Goal')),
                ])),
          ],
        ));
  }
}
