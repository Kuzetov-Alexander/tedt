import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'university_model.g.dart';

@immutable
@JsonSerializable(createToJson: false)
final class UniversityModel {
  final List<String>? domains;
  final String? country;
  final String? name;
  final List<String>? webPage;
  final String? alphaTwoCode;

  const UniversityModel({
    required this.domains,
    required this.country,
    required this.name,
    required this.webPage,
    required this.alphaTwoCode,
  });

  factory UniversityModel.fromJson(Map<String, Object?> json) =>
      _$UniversityModelFromJson(json);
}
