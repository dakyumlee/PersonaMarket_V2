import 'api_service.dart';
import '../models/persona.dart';

class PersonaService {
  final ApiService _apiService = ApiService();

  Future<Persona> createPersona(Map<String, dynamic> data) async {
    final response = await _apiService.post('/personas', data, includeAuth: true);
    return Persona.fromJson(response);
  }

  Future<Persona> updatePersona(int id, Map<String, dynamic> data) async {
    final response = await _apiService.put('/personas/$id', data, includeAuth: true);
    return Persona.fromJson(response);
  }

  Future<Persona> getPersona(int id) async {
    final response = await _apiService.get('/personas/$id', includeAuth: false);
    return Persona.fromJson(response);
  }

  Future<List<Persona>> getPublicPersonas() async {
    final response = await _apiService.get('/personas/public', includeAuth: false);
    return (response['content'] as List)
        .map((json) => Persona.fromJson(json))
        .toList();
  }

  Future<List<Persona>> searchPersonas(String keyword) async {
    final response = await _apiService.get('/personas/search?keyword=$keyword', includeAuth: false);
    return (response['content'] as List)
        .map((json) => Persona.fromJson(json))
        .toList();
  }

  Future<void> deletePersona(int id) async {
    await _apiService.delete('/personas/$id', includeAuth: true);
  }
}
