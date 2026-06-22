/// Mixin reutilizable que traduce errores de red/servidor a mensajes
/// legibles para el usuario.
///
/// Es un mixin libre (sin cláusula `on`), por lo que cualquier clase puede
/// mezclarlo para reutilizar el mapeo de errores comunes.
mixin NetworkErrorMixin {
  /// Mapea los errores comunes (sin conexión, timeout, 500...).
  String mapNetworkError(Object error) {
    final msg = error.toString();
    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Failed host lookup') ||
        msg.contains('Network is unreachable')) {
      return 'Sin conexión con el servidor';
    }
    if (msg.contains('TimeoutException')) {
      return 'El servidor tardó demasiado en responder';
    }
    if (msg.contains('500') || msg.contains('502') || msg.contains('503')) {
      return 'Error interno del servidor. Intenta más tarde.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }

  /// Intenta extraer el mensaje original que envió el servidor en el cuerpo
  /// de la excepción (formato: '... (codigo): mensaje del servidor').
  String? extractServerMessage(Object error) {
    final match = RegExp(r'\(\d{3}\):\s*(.+)$').firstMatch(error.toString());
    final serverMsg = match?.group(1)?.trim();
    if (serverMsg != null &&
        serverMsg.isNotEmpty &&
        serverMsg != 'Sin respuesta del servidor') {
      return serverMsg;
    }
    return null;
  }
}
