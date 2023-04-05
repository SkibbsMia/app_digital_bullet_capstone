import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:digital_bullet/habitspage.dart';
import 'package:digital_bullet/journalpage.dart';
import 'package:digital_bullet/notespage.dart';
import 'package:digital_bullet/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digital_bullet/todopage.dart';
import 'package:digital_bullet/goalpage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Initiate the application
Future<void> main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'overdue_channel_group',
            channelKey: 'overdue_channel',
            channelName: 'Overdue Notifications',
            channelDescription: 'Notifications For Digital Bullet',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'overdue_channel_group',
            channelGroupName: 'Overdue group')
      ],
      debug: true);

  NotificationController.scheduleNewNotification();

  runApp(ResponsiveSizer(
    builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorKey: HomeRoute.navigatorKey,
        initialRoute: "/",
        routes: {
          '/': (context) => const HomeRoute(),
          '/todo': (context) => const ToDoPage(),
          '/habits': (context) => const HabitPage(),
          '/goals': (context) => const GoalPage(),
          '/journal': (context) => const JournalPage(),
          '/notes': (context) => const NotesPage(),
        },
      );
    },
  ));
}

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            Device.screenType == ScreenType.tablet
                ? Image.asset(
                    'lib/assets/HomeScreenBackground.png',
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 1.05,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    'lib/assets/HomeScreenBackground.png',
                    width: 350,
                    height: 750,
                    fit: BoxFit.fill,
                  ),
          ],
        ));
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    HomeRoute.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }

  static Future<void> scheduleNewNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 12, // -1 is replaced by a random number
          channelKey: 'overdue_channel',
          title: "Daily Journal!",
          body: "A gentle reminder to write your PM Daily Journal!",
        ),
        schedule: NotificationCalendar(
            hour: 16, minute: 00, second: 00, repeats: true));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 13, // -1 is replaced by a random number
          channelKey: 'overdue_channel',
          title: "Daily Journal!",
          body: "A gentle reminder to write your AM Daily Journal!",
        ),
        schedule: NotificationCalendar(
            hour: 7, minute: 00, second: 00, repeats: true));
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
