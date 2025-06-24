import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notificaciones_service.dart';


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
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addEvent(String title) {
    if (title.isEmpty || _selectedDay == null) {
      _showMessage("Por favor escribe un evento");
      return;
    }

    if (_selectedTime == null) {
      _showMessage("Por favor selecciona una hora");
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    if (eventDay.isBefore(today)) {
      _showMessage("No puedes agregar eventos en fechas pasadas");
      return;
    }

    final formattedTime = _selectedTime!.format(context);
    final fullEvent = "$title - $formattedTime";

    setState(() {
      if (_events[eventDay] != null) {
        _events[eventDay]!.add(fullEvent);
      } else {
        _events[eventDay] = [fullEvent];
      }
      NotificacionesService.agregar(
      "Nuevo evento: \"$title\" a las $formattedTime el ${eventDay.day}/${eventDay.month}/${eventDay.year}"
    );
      _eventController.clear();
      _selectedTime = null;
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
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.purple[200],
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
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
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: _pickTime,
                      tooltip: 'Seleccionar hora',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _addEvent(_eventController.text),
                  child: Text('Agregar evento'),
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
    );
  }
}
