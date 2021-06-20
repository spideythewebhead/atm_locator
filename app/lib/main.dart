import 'package:app/blocs/main_bloc.dart';
import 'package:app/env_config.dart';
import 'package:app/http.dart';
import 'package:app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  print(EnvConfig.baseUrl);
  final httpClient = AppClientHttp(
    dio,
    baseUrl: EnvConfig.baseUrl,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<MainBloc>(
          create: (_) {
            return MainBloc(httpClient);
          },
          lazy: true,
          dispose: (_, bloc) {
            bloc.dispose();
            dio.close();
          },
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xff2f5082),
        accentColor: Colors.amberAccent,
        textTheme: TextTheme(
          bodyText1: const TextStyle(fontSize: 16.0),
          bodyText2: const TextStyle(fontSize: 14.0),
          button: const TextStyle(fontSize: 16.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          elevation: 4.0,
          shape: const StadiumBorder(),
          minimumSize: Size(96.0, 40.0),
        )),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: Size(96.0, 40.0),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xff2f5082),
        accentColor: Colors.deepOrange,
        textTheme: TextTheme(
          bodyText1: const TextStyle(fontSize: 16.0),
          bodyText2: const TextStyle(fontSize: 14.0),
          button: const TextStyle(fontSize: 16.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          elevation: 4.0,
          shape: const StadiumBorder(),
          minimumSize: Size(96.0, 40.0),
        )),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: Size(96.0, 40.0),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      routes: {
        HomePage.route: (_) => HomePage(),
      },
    );
  }
}
