import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class NoteDatamodel {
  NoteDatamodel(this.id, this.tlt, this.desc, this.cdnt, this.udnt);

  final String id;
  final String tlt;
  final String desc;
  final int udnt;
  final int cdnt;

  factory NoteDatamodel.fromJson(Map<String, dynamic> json) =>
      _$NoteDatamodelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteDatamodelToJson(this);
}
