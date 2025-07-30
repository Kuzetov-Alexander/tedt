import 'dart:convert';
import 'package:flutter_application_1/models/university_model.dart';
import 'package:http/http.dart' as http;

abstract interface class UniversityRepository {
  Future<List<UniversityModel>> fetchUniversities({
    required String name,
    required int offset,
    required int limit,
    String? country,
  });
}

class UniversityRepositoryImpl implements UniversityRepository {
  @override
  Future<List<UniversityModel>> fetchUniversities({
    required String name,
    required int offset,
    required int limit,
    String? country,
  }) async {
    final Uri uri = Uri.parse('http://universities.hipolabs.com/search')
        .replace(
          queryParameters: {
            'name': name,
            'country': country,
            'offset': offset.toString(),
            'limit': limit.toString(),
          },
        );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonRaw = jsonDecode(response.body);
      return jsonRaw
          .map((dynamic item) => UniversityModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
