// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleImpl _$$ScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleImpl(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      fleetId: json['fleetId'] as String,
      driverId: json['driverId'] as String?,
      day: json['day'] as String,
      time: const TimestampConverter()
          .fromJson(json['time'] as Map<String, dynamic>),
      routeName: json['routeName'] as String?,
      routePath: (json['routePath'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      collectionsPath: (json['collectionsPath'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      fleetStatus: json['fleetStatus'] as String?,
    );

Map<String, dynamic> _$$ScheduleImplToJson(_$ScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'fleetId': instance.fleetId,
      'driverId': instance.driverId,
      'day': instance.day,
      'time': const TimestampConverter().toJson(instance.time),
      'routeName': instance.routeName,
      'routePath': instance.routePath,
      'collectionsPath': instance.collectionsPath,
      'fleetStatus': instance.fleetStatus,
    };
