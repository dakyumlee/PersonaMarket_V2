import 'api_service.dart';

class BreedingService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> breedPersonas(
    int parent1Id,
    int parent2Id,
    String childName,
  ) async {
    final response = await _apiService.post(
      '/breeding',
      {
        'parent1Id': parent1Id,
        'parent2Id': parent2Id,
        'childName': childName,
      },
      includeAuth: true,
    );
    return response;
  }
}
