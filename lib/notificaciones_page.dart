import 'package:flutter/material.dart';
import 'notificaciones_service.dart';

class NotificacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificaciones = NotificacionesService.obtener();

    return Scaffold(
      appBar: AppBar(title: Text('Notificaciones')),
      body: notificaciones.isEmpty
          ? Center(child: Text('No hay notificaciones'))
          : ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(notificaciones[index]),
                );
              },
            ),
    );
  }
}
