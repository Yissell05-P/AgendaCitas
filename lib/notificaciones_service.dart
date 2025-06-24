class NotificacionesService {
  static final List<String> _notificaciones = [];

  static void agregar(String mensaje) {
    _notificaciones.add(mensaje);
  }

  static List<String> obtener() {
    return _notificaciones.reversed.toList(); // mostrar las más recientes arriba
  }

  static void limpiar() {
    _notificaciones.clear();
  }
}
