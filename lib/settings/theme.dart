import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ThemeMain extends StatelessWidget {
  const ThemeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  ThemeData lightTheme() {
    return ThemeData().copyWith(
         pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android:
              PageTransition(type: PageTransitionType.rightToLeft, child: this)
                  .matchingBuilder,
        }),
      listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.black)),
      colorScheme: ColorScheme.fromSeed(
          onPrimaryContainer: Colors.grey,
          primaryContainer: Colors.grey,
          primary: Colors.blue,
          secondaryContainer: Colors.white,
          onSurface: Colors.black,
          surface: const Color.fromARGB(255, 255, 255, 255),
          background: Colors.white,
          onBackground: Colors.black,
          onSecondary: const Color.fromARGB(255, 62, 0, 206),
          seedColor: const Color.fromARGB(255, 255, 255, 255)),
    );
  }

   ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white)),
      colorScheme: const ColorScheme(
        /* onPrimaryContainer: Colors.green,
            primaryContainer: Colors.green,
            secondaryContainer: Colors.black, */
        brightness: Brightness.dark,
        primary: Color.fromARGB(255, 5, 5, 5),
        onPrimary: Colors.black,
        secondary: Color.fromARGB(255, 76, 0, 255),
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Color.fromRGBO(18, 18, 18, 1),
        onBackground: Color.fromARGB(255, 255, 255, 255),
        surface: Color.fromARGB(255, 34, 34, 34),
        onSurface: Colors.black,
      ),
    );
  }
} 


