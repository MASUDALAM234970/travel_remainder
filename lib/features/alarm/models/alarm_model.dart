import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  bool isEnabled;

  @HiveField(3)
  String? location;

  AlarmModel({
    required this.id,
    required this.dateTime,
    this.isEnabled = true,
    this.location,
  });

  AlarmModel copyWith({
    String? id,
    DateTime? dateTime,
    bool? isEnabled,
    String? location,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      isEnabled: isEnabled ?? this.isEnabled,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'isEnabled': isEnabled,
      'location': location,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      isEnabled: json['isEnabled'] ?? true,
      location: json['location'],
    );
  }
}
