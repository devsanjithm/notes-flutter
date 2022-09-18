// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteDatamodel _$NoteDatamodelFromJson(Map<String, dynamic> json) =>
    NoteDatamodel(
      json['id'] as String,
      json['tlt'] as String,
      json['desc'] as String,
      json['cdnt'] as int,
      json['udnt'] as int,
    );

Map<String, dynamic> _$NoteDatamodelToJson(NoteDatamodel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tlt': instance.tlt,
      'desc': instance.desc,
      'udnt': instance.udnt,
      'cdnt': instance.cdnt,
    };
