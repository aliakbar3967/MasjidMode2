import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:muslim_mate/Providers/AzkarProvider.dart';
import 'package:muslim_mate/Providers/CitiesProvider.dart';
import 'package:muslim_mate/Providers/MosquesProvider.dart';
import 'package:muslim_mate/Providers/PlaceProvider.dart';
import 'package:muslim_mate/Providers/PrayersProvider.dart';
import 'package:muslim_mate/Providers/SuwarProvider.dart';
import 'package:muslim_mate/constant.dart';
import 'package:muslim_mate/job/Algorithm.dart';
import 'package:muslim_mate/provider/ScheduleProvider.dart';
import 'package:muslim_mate/provider/SettingsProvider.dart';
import 'job/Algorithm.dart';
import 'constant.dart';


import 'package:provider/provider.dart';
//Screens
import 'Screens/Home_Screen.dart';
//Utils
import 'Utils/Constants.dart';

@pragma('vm:entry-point')
void arcReactor() async => await algorithm();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await ClearAllNotifications.clear();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // Provider<ScheduleController>(create: (context) => ScheduleController())
      ],
      child: const MyApp(),
    ),
  );

  
  await AndroidAlarmManager.periodic( 
    const Duration(minutes: 1),
    Constant.ARC_REACTOR_ID,
    arcReactor,
    wakeup: true,
    exact: true,
    allowWhileIdle: true,
    rescheduleOnReboot: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlaceProvider()),
        ChangeNotifierProvider(create: (context) => MosquesProvider()),
        ChangeNotifierProvider(create: (context) => CitiesProvider()),
        ChangeNotifierProvider(create: (context) => PrayersProvider()),
        ChangeNotifierProvider(create: (context) => SuwarProvider()),
        ChangeNotifierProvider(create: (context) => AzkarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Masjid Mode',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor)),
        home: AnimatedSplashScreen(
          splash: appIcon,
          nextScreen: const HomeScreen(),
          splashIconSize: 220,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ),
    );
  }
}
