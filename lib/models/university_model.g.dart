// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UniversityModel _$UniversityModelFromJson(Map<String, dynamic> json) =>
    UniversityModel(
      domains: (json['domains'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      country: json['country'] as String?,
      name: json['name'] as String?,
      webPage: (json['webPage'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      alphaTwoCode: json['alphaTwoCode'] as String?,
    );
