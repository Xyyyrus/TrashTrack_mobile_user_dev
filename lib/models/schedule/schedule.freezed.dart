// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  String get id => throw _privateConstructorUsedError;
  String get routeId => throw _privateConstructorUsedError;
  String get fleetId => throw _privateConstructorUsedError;
  String? get driverId =>
      throw _privateConstructorUsedError; // Made this field optional by using String? instead of required String
  String get day => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp get time => throw _privateConstructorUsedError;
  String? get routeName => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get routePath =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get collectionsPath =>
      throw _privateConstructorUsedError;
  String? get fleetStatus => throw _privateConstructorUsedError;

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call(
      {String id,
      String routeId,
      String fleetId,
      String? driverId,
      String day,
      @TimestampConverter() Timestamp time,
      String? routeName,
      List<Map<String, dynamic>>? routePath,
      List<Map<String, dynamic>>? collectionsPath,
      String? fleetStatus});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? fleetId = null,
    Object? driverId = freezed,
    Object? day = null,
    Object? time = null,
    Object? routeName = freezed,
    Object? routePath = freezed,
    Object? collectionsPath = freezed,
    Object? fleetStatus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: null == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      fleetId: null == fleetId
          ? _value.fleetId
          : fleetId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      routeName: freezed == routeName
          ? _value.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String?,
      routePath: freezed == routePath
          ? _value.routePath
          : routePath // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      collectionsPath: freezed == collectionsPath
          ? _value.collectionsPath
          : collectionsPath // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      fleetStatus: freezed == fleetStatus
          ? _value.fleetStatus
          : fleetStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleImplCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$$ScheduleImplCopyWith(
          _$ScheduleImpl value, $Res Function(_$ScheduleImpl) then) =
      __$$ScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String routeId,
      String fleetId,
      String? driverId,
      String day,
      @TimestampConverter() Timestamp time,
      String? routeName,
      List<Map<String, dynamic>>? routePath,
      List<Map<String, dynamic>>? collectionsPath,
      String? fleetStatus});
}

/// @nodoc
class __$$ScheduleImplCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$ScheduleImpl>
    implements _$$ScheduleImplCopyWith<$Res> {
  __$$ScheduleImplCopyWithImpl(
      _$ScheduleImpl _value, $Res Function(_$ScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? fleetId = null,
    Object? driverId = freezed,
    Object? day = null,
    Object? time = null,
    Object? routeName = freezed,
    Object? routePath = freezed,
    Object? collectionsPath = freezed,
    Object? fleetStatus = freezed,
  }) {
    return _then(_$ScheduleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routeId: null == routeId
          ? _value.routeId
          : routeId // ignore: cast_nullable_to_non_nullable
              as String,
      fleetId: null == fleetId
          ? _value.fleetId
          : fleetId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      routeName: freezed == routeName
          ? _value.routeName
          : routeName // ignore: cast_nullable_to_non_nullable
              as String?,
      routePath: freezed == routePath
          ? _value._routePath
          : routePath // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      collectionsPath: freezed == collectionsPath
          ? _value._collectionsPath
          : collectionsPath // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      fleetStatus: freezed == fleetStatus
          ? _value.fleetStatus
          : fleetStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleImpl implements _Schedule {
  const _$ScheduleImpl(
      {required this.id,
      required this.routeId,
      required this.fleetId,
      this.driverId,
      required this.day,
      @TimestampConverter() required this.time,
      this.routeName,
      final List<Map<String, dynamic>>? routePath,
      final List<Map<String, dynamic>>? collectionsPath,
      this.fleetStatus})
      : _routePath = routePath,
        _collectionsPath = collectionsPath;

  factory _$ScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String routeId;
  @override
  final String fleetId;
  @override
  final String? driverId;
// Made this field optional by using String? instead of required String
  @override
  final String day;
  @override
  @TimestampConverter()
  final Timestamp time;
  @override
  final String? routeName;
  final List<Map<String, dynamic>>? _routePath;
  @override
  List<Map<String, dynamic>>? get routePath {
    final value = _routePath;
    if (value == null) return null;
    if (_routePath is EqualUnmodifiableListView) return _routePath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _collectionsPath;
  @override
  List<Map<String, dynamic>>? get collectionsPath {
    final value = _collectionsPath;
    if (value == null) return null;
    if (_collectionsPath is EqualUnmodifiableListView) return _collectionsPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? fleetStatus;

  @override
  String toString() {
    return 'Schedule(id: $id, routeId: $routeId, fleetId: $fleetId, driverId: $driverId, day: $day, time: $time, routeName: $routeName, routePath: $routePath, collectionsPath: $collectionsPath, fleetStatus: $fleetStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.fleetId, fleetId) || other.fleetId == fleetId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            const DeepCollectionEquality()
                .equals(other._routePath, _routePath) &&
            const DeepCollectionEquality()
                .equals(other._collectionsPath, _collectionsPath) &&
            (identical(other.fleetStatus, fleetStatus) ||
                other.fleetStatus == fleetStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routeId,
      fleetId,
      driverId,
      day,
      time,
      routeName,
      const DeepCollectionEquality().hash(_routePath),
      const DeepCollectionEquality().hash(_collectionsPath),
      fleetStatus);

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      __$$ScheduleImplCopyWithImpl<_$ScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleImplToJson(
      this,
    );
  }
}

abstract class _Schedule implements Schedule {
  const factory _Schedule(
      {required final String id,
      required final String routeId,
      required final String fleetId,
      final String? driverId,
      required final String day,
      @TimestampConverter() required final Timestamp time,
      final String? routeName,
      final List<Map<String, dynamic>>? routePath,
      final List<Map<String, dynamic>>? collectionsPath,
      final String? fleetStatus}) = _$ScheduleImpl;

  factory _Schedule.fromJson(Map<String, dynamic> json) =
      _$ScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get routeId;
  @override
  String get fleetId;
  @override
  String?
      get driverId; // Made this field optional by using String? instead of required String
  @override
  String get day;
  @override
  @TimestampConverter()
  Timestamp get time;
  @override
  String? get routeName;
  @override
  List<Map<String, dynamic>>? get routePath;
  @override
  List<Map<String, dynamic>>? get collectionsPath;
  @override
  String? get fleetStatus;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
