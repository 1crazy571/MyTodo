import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/0_screens/first_screen.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo/data/provider.dart';
import 'package:todo/0_screens/0_home_page.dart';
import 'package:todo/settings/notification_controller.dart';
import 'package:todo/settings/theme.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'data/database.dart';

void main() async {
  timeDilation = 1;
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: "Basic notifications channel",
      )
    ],
  );
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  await userDatabaseProvider.initialize();


  runApp(
    ChangeNotifierProvider(
      child: MainApp(
        myPref: prefs,
      ),
      create: (context) => ToDoProvider(),
    ),
  );
}

class MainApp extends StatefulWidget {
 const MainApp({super.key, required this.myPref});
final  SharedPreferences myPref;
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  RenderBox? renderbox;
  late bool isFirstScreen;

  @override
  void initState() {
    isFirstScreen =  widget.myPref.getBool("firstScreen") ?? true ;

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        renderbox = context.findRenderObject() as RenderBox;
      },
    );
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit(),
      child: Consumer<ToDoProvider>(
        builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              provider.changeRenderBox(renderbox!);
            },
          );

          return MaterialApp(
            locale: const Locale("en"),
            supportedLocales: const [Locale("tr"), Locale("en")],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizations.delegate, // Bu satır önemli
            ],
            debugShowCheckedModeBanner: false,
            theme: const ThemeMain().lightTheme(),
            darkTheme: const ThemeMain().darkTheme(),
            themeMode: ThemeMode.system,
            home: isFirstScreen ? const FirstScreen() : const TodoHomePage(),
            //    home: const TodoHomePage(),
          );
        },
      ),
    );
  }
}
