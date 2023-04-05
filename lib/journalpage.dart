import 'package:digital_bullet/tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_bullet/database/sql_journal_helper.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<Map<String, dynamic>> _todayAmEntry = [];
  List<Map<String, dynamic>> _todayPmEntry = [];

  String currentDisplayedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late int subtractedDays = 0;

  late bool isReadOnly = false;
  late bool pmActive = false;

  final TextEditingController _entryController = TextEditingController();

  void _getAmEntry() async {
    final data = await SQLJournalHelper.getAMEntry(currentDisplayedDate);
    setState(() {
      _todayAmEntry = data;
    });
    // If today's date is not empty display entry.
    if (!pmActive) {
      if (_todayAmEntry.isNotEmpty) {
        _entryController.text = _todayAmEntry[0]['entry'];
      } else {
        _entryController.text = '';
      }
    }
  }

  void _getPmEntry() async {
    final data = await SQLJournalHelper.getPMEntry(currentDisplayedDate);
    setState(() {
      _todayPmEntry = data;
    });
    if (pmActive) {
      // If today's date is not empty display entry.
      if (_todayPmEntry.isNotEmpty) {
        _entryController.text = _todayPmEntry[0]['entry'];
      } else {
        _entryController.text = '';
      }
    }
  }

  Future<void> _addAmEntry() async {
    await SQLJournalHelper.createAMEntry(_entryController.text);
    _getAmEntry();
  }

  Future<void> _addPmEntry() async {
    await SQLJournalHelper.createPMEntry(_entryController.text);
    _getPmEntry();
  }

  Future<void> _updateAmEntry() async {
    await SQLJournalHelper.updateAMEntry(
        _todayAmEntry[0]['id'], _entryController.text);
    _getAmEntry();
  }

  Future<void> _updatePmEntry() async {
    await SQLJournalHelper.updatePMEntry(
        _todayPmEntry[0]['id'], _entryController.text);
    _getPmEntry();
  }

  @override
  void initState() {
    super.initState();
    _getAmEntry();
    _getPmEntry();
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
    return Device.screenType == ScreenType.tablet
        ? SizedBox(
            width: Adaptive.w(121),
            height: MediaQuery.of(context).size.height * 1,
            child: Stack(children: [
              backgroundWidget(context),
              mainBodyWidget(),
              const TabBarSection(),
            ]),
          )
        : SizedBox(
            width: Adaptive.w(135),
            height: MediaQuery.of(context).size.height * 1,
            child: Stack(children: [
              backgroundWidget(context),
              mainBodyWidget(),
              const TabBarSection(),
            ]),
          );
  }

  Image backgroundWidget(BuildContext context) {
    return Device.screenType == ScreenType.tablet
        ? Image.asset(
            'lib/assets/DotBackground.png',
            width: MediaQuery.of(context).size.width * 1.2,
            height: MediaQuery.of(context).size.height * 1,
            fit: BoxFit.fitHeight,
          )
        : Image.asset(
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.06,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text(
                      "Journal",
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
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 7,
                      alignment: Alignment.center,
                      child: Text(currentDisplayedDate)),
                  Container(
                    padding: const EdgeInsets.only(left: 19, bottom: 40),
                    width: MediaQuery.of(context).size.width / 1.25,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _entryController,
                      readOnly: isReadOnly,
                      minLines: 30,
                      maxLines: 30,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        hintText: todayDate == currentDisplayedDate
                            ? 'Write Entry Here'
                            : 'N/A',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              pmActive = true;

                              // If today's date is not empty display entry.
                              if (_todayPmEntry.isNotEmpty) {
                                _entryController.text =
                                    _todayPmEntry[0]['entry'];
                              } else {
                                _entryController.text = '';
                              }
                            });
                          },
                          icon: Icon(
                              pmActive == false
                                  ? CupertinoIcons.moon
                                  : CupertinoIcons.moon_fill,
                              color: pmActive == true ? null : Colors.black26),
                        ),
                        Text(
                          'PM',
                          style: TextStyle(
                              color: pmActive == true ? null : Colors.black26),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              pmActive = false;

                              // If today's date is not empty display entry.
                              if (_todayAmEntry.isNotEmpty) {
                                _entryController.text =
                                    _todayAmEntry[0]['entry'];
                              } else {
                                _entryController.text = '';
                              }
                            });

                            // if it does make the current entry, do nothing
                          },
                          icon: Icon(
                              pmActive != true
                                  ? CupertinoIcons.sun_min_fill
                                  : CupertinoIcons.sun_min,
                              color: pmActive != true ? null : Colors.black26),
                        ),
                        Text(
                          'AM',
                          style: TextStyle(
                              color: pmActive != true ? null : Colors.black26),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 1.18,
                    child: IconButton(
                      onPressed: () async {
                        // if I am allowed to submit
                        if (isReadOnly == false) {
                          // if pm is displayed
                          if (pmActive) {
                            if (_todayPmEntry.isEmpty) {
                              _addPmEntry();
                            } else {
                              _updatePmEntry();
                            }
                          }

                          // if am is displayed
                          if (!pmActive) {
                            // if we need to update or add entry
                            if (_todayAmEntry.isEmpty) {
                              _addAmEntry();
                            } else {
                              _updateAmEntry();
                            }
                          }
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.add_circled_solid,
                        size: 40,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 1.18,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (currentDisplayedDate != todayDate) {
                            subtractedDays--;
                            currentDisplayedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now()
                                    .subtract(Duration(days: subtractedDays)));
                            pmActive = false;
                            _getAmEntry();
                            _getPmEntry();
                            if (currentDisplayedDate == todayDate) {
                              isReadOnly = false;
                            }
                          }
                        });
                      },
                      icon: Icon(Icons.chevron_right,
                          size: 40,
                          color: currentDisplayedDate == todayDate
                              ? Colors.white24
                              : Colors.black),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 1.18,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            // subtract days to today's date
                            subtractedDays++;
                            currentDisplayedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now()
                                    .subtract(Duration(days: subtractedDays)));
                            pmActive = false;
                            isReadOnly = true;
                            _getAmEntry();
                            _getPmEntry();
                          });
                        },
                        icon: const Icon(Icons.chevron_left,
                            size: 40, color: Colors.black)),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
