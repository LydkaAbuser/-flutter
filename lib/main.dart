import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/main_screen.dart';
import 'screens/cubit/main_screen_cubit.dart';
import 'screens/nasa_weather_screen.dart';
import 'screens/cubit/nasa_weather_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainScreenCubit()),
        BlocProvider(create: (context) => NasaWeatherCubit()),
      ],
      child: MaterialApp(
        title: 'Лабораторная работа - Прокопенко И.А.',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 98, 139, 173),
          ),
        ),
        home: HomeNavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeNavigationScreen extends StatefulWidget {
  @override
  _HomeNavigationScreenState createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    NasaWeatherScreen(),
  ];

  final List<String> _appBarTitles = [
    'Калькулятор ускорения',
    'Погода на Марсе',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Color.fromARGB(255, 98, 139, 173),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Калькулятор',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'NASA Mars',
          ),
        ],
      ),
    );
  }
}