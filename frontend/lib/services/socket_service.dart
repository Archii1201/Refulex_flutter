import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  IO.Socket? socket;

  void connect(String token, String userId) {
    final url = dotenv.env['SOCKET_URL'] ?? dotenv.env['API_BASE_URL'] ?? '';
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Authorization': 'Bearer $token'},
    });

    socket?.on('connect', (_) {
      socket?.emit('joinRoom', {'room': userId});
    });
  }

  void on(String event, Function(dynamic) cb) => socket?.on(event, cb);
  void off(String event) => socket?.off(event);
  void disconnect() => socket?.disconnect();
}