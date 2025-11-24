import 'api_service.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> sendMessage(int personaId, String message) async {
    final response = await _apiService.post('/chat', {
      'personaId': personaId,
      'message': message,
    });
    return response;
  }
}
