import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({Key? key}) : super(key: key);

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
  @override
  Widget build(BuildContext context) {
    return _tabBarWidget(context);
  }

  Widget _tabBarWidget(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          homeTabWidget(context),
          const SizedBox(
            height: 10,
          ),
          todoTabWidget(context),
          const SizedBox(
            height: 10,
          ),
          habitsTabWidget(context),
          const SizedBox(
            height: 10,
          ),
          goalsTabWidget(context),
          const SizedBox(
            height: 10,
          ),
          journalTabWidget(context),
          const SizedBox(
            height: 10,
          ),
          notesTabWidget(context),
          const SizedBox(
            height: 10,
          )
        ]));
  }

  Stack notesTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/notes") {
                        Navigator.pushNamed(context, '/notes');
                      }
                    },
                  );
                },
                child: const Text(
                  "Notes",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/notes") {
                        Navigator.pushNamed(context, '/notes');
                      }
                    },
                  );
                },
                child: const Text(
                  "Notes",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }

  Stack journalTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/journal") {
                        Navigator.pushNamed(context, '/journal');
                      }
                    },
                  );
                },
                child: const Text(
                  "Journal",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/journal") {
                        Navigator.pushNamed(context, '/journal');
                      }
                    },
                  );
                },
                child: const Text(
                  "Journal",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }

  Stack habitsTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/habits") {
                        Navigator.pushNamed(context, '/habits');
                      }
                    },
                  );
                },
                child: const Text(
                  "Habits",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/habits") {
                        Navigator.pushNamed(context, '/habits');
                      }
                    },
                  );
                },
                child: const Text(
                  "Habits",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }

  Stack goalsTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/goals") {
                        Navigator.pushNamed(context, '/goals');
                      }
                    },
                  );
                },
                child: const Text(
                  "Goals",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/goals") {
                        Navigator.pushNamed(context, '/goals');
                      }
                    },
                  );
                },
                child: const Text(
                  "Goals",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }

  Stack todoTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/todo") {
                        Navigator.pushNamed(context, '/todo');
                      }
                    },
                  );
                },
                child: const Text(
                  "To Do",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/todo") {
                        Navigator.pushNamed(context, '/todo');
                      }
                    },
                  );
                },
                child: const Text(
                  "To Do",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }

  Stack homeTabWidget(context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Device.screenType == ScreenType.tablet
          ? Image.asset(
              'lib/assets/TabPicture.png',
              width: 270,
              height: 75,
            )
          : Image.asset(
              'lib/assets/TabPicture.png',
              width: 180,
              height: 50,
            ),
      Device.screenType == ScreenType.tablet
          ? Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 270,
              height: 75,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/") {
                        Navigator.pushNamed(context, '/');
                      }
                    },
                  );
                },
                child: const Text(
                  "Home",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 10, 0),
              width: 180,
              height: 50,
              child: BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 0.5,
                onPressed: () {
                  setState(
                    () {
                      if (ModalRoute.of(context)?.settings.name != "/") {
                        Navigator.pushNamed(context, '/');
                      }
                    },
                  );
                },
                child: const Text(
                  "Home",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic2',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    ]);
  }
}
