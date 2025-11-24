import 'api_service.dart';

class FineTuneService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> startFineTuning(int personaId) async {
    final response = await _apiService.post(
      '/finetune/start',
      {'personaId': personaId},
    );
    return response;
  }

  Future<Map<String, dynamic>> checkStatus(String jobId) async {
    final response = await _apiService.get('/finetune/status/$jobId');
    return response;
  }
}
