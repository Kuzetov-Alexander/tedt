import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/university_model.dart';
import 'package:flutter_application_1/repository.dart';

class SearchProvider extends ChangeNotifier {
  final UniversityRepository _repository;
  final List<UniversityModel> _universities = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitialLoad = false;
  int _offset = 0;
  int _limit = 10;
  String _query = '';
  String? _countryQuery;

  SearchProvider({required UniversityRepository repository})
    : _repository = repository;

  List<UniversityModel> get universities => _universities;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get isInitialLoad => _isInitialLoad;

  void reset() {
    _universities.clear();
    _offset = 0;
    _hasMore = true;
    _limit = 10;
    notifyListeners();
  }

  Future<void> search({required String name, required String? country}) async {
    _query = name;
    _countryQuery = (country?.isNotEmpty ?? false) ? country : null;

    reset();
    _isInitialLoad = true;
    notifyListeners();
    await loadMore();
    _isInitialLoad = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore || _query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _repository.fetchUniversities(
        name: _query,
        offset: _offset,
        limit: _limit,
        country: _countryQuery,
      );

      _universities.addAll(results);
      _offset += _limit;
      _hasMore = results.length == _limit;

      _limit = 5;
    } catch (e) {
      log('Ошибка загрузки: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
