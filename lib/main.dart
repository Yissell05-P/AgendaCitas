import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'profile_screen.dart';
import 'notificaciones_page.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App con Calendario',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F0FF),
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(), // Pantalla principal con navegación
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    ProfileScreen(),    // índice 0
    CalendarPage(),     // índice 1
    NotificacionesPage(),// indice 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 161, 89, 244),
        unselectedItemColor: const Color.fromARGB(255, 48, 148, 148),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
      ),
    );
  }
}
