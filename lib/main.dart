import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 185, 187, 187), // Fondo gris
        primarySwatch: Colors.teal, // Color de la AppBar
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};
  final TextEditingController _eventController = TextEditingController();
  int _selectedIndex = 1; // Para controlar la barra inferior

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {
      DateTime.now(): ['Evento 1', 'Evento 2'],
    };
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _addEvent(String title) {
    if (title.isEmpty || _selectedDay == null) return;

    final eventDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      if (_events[eventDay] != null) {
        _events[eventDay]!.add(title);
      } else {
        _events[eventDay] = [title];
      }
      _eventController.clear();
    });
  }

  void _deleteEvent(int index) {
    final eventDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      _events[eventDay]!.removeAt(index);
      if (_events[eventDay]!.isEmpty) {
        _events.remove(eventDay);
      }
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar evento'),
        content: Text('¿Deseas eliminar este evento?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(
            onPressed: () {
              _deleteEvent(index);
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: const Color.fromARGB(255, 230, 102, 92))),
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Aquí podrías navegar a diferentes pantallas
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ir a Perfil")));
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ir a Notificaciones")));
    } else if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ir a Configuración")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay(_selectedDay!);

    return Scaffold(
      appBar: AppBar(title: Text('Calendario')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 109, 25, 204),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 193, 152, 240),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: const Color.fromARGB(255, 251, 251, 251)),
              todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      labelText: 'Nuevo evento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addEvent(_eventController.text),
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        selectedItemColor: const Color.fromARGB(255, 161, 89, 244),
        unselectedItemColor: const Color.fromARGB(255, 48, 148, 148),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
    );
  }
}
