import 'package:equatable/equatable.dart';

/// Example:
///
/// {
///   "code": "0",
///   "message": "Success",
///   "data": {
///     "insert_date": "2023-06-19T12:18:30.519Z",
///     "insert_user": null,
///     "update_date": "2023-06-20T07:13:56.285Z",
///     "update_user": null,
///     "delete_flag": null,
///     "delete_date": null,
///     "delete_user": null,
///     "active_flg": 1,
///     "attendance_id": 36,
///     "shift_id": 14,
///     "employee_id": 1212,
///     "isNextDay": true,
///     "isClosed": false,
///     "clock_in": "2023-06-19T12:18:30.519Z",
///     "clock_out": null
///   },
///   "alt": {
///     "insert_date": "2023-06-19T12:18:30.519Z",
///     "insert_user": null,
///     "update_date": "2023-06-20T07:13:56.285Z",
///     "update_user": null,
///     "delete_flag": null,
///     "delete_date": null,
///     "delete_user": null,
///     "active_flg": 1,
///     "attendance_id": 36,
///     "shift_id": 14,
///     "employee_id": 1212,
///     "isNextDay": true,
///     "isClosed": false,
///     "clock_in": "2023-06-19T12:18:30.519Z",
///     "clock_out": null
///   },
///   "clock_in_flag": false,
///   "clock_out_flag": false,
///   "ids": [
///     123,
///     456,
///     789
///   ],
///   "employees": [
///     {
///       "fullname": "Budi Budianto"
///     }
///   ]
/// }
class Dummy extends Equatable {
  final String? code;
  final String? message;
  final DummyData? data;
  final DummyAlt? alt;
  final bool? clockInFlag;
  final bool? clockOutFlag;
  final List<int>? ids;
  final List<DummyEmployee>? employees;

  const Dummy({
    required this.code,
    required this.message,
    required this.data,
    required this.alt,
    required this.clockInFlag,
    required this.clockOutFlag,
    required this.ids,
    required this.employees,
  });

  factory Dummy.fromJson(Map json) {
    return Dummy(
      code: json["code"],
      message: json["message"],
      data: DummyData.fromJson(json["data"] ?? {}),
      alt: DummyAlt.fromJson(json["alt"] ?? {}),
      clockInFlag: json["clock_in_flag"],
      clockOutFlag: json["clock_out_flag"],
      ids: (json["ids"] as List?)?.map((e) => e as int).toList(),
      employees: (json["employees"] as List?)
          ?.map((e) => DummyEmployee.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "data": data?.toJson(),
      "alt": alt?.toJson(),
      "clock_in_flag": clockInFlag,
      "clock_out_flag": clockOutFlag,
      "ids": ids?.map((e) => e).toList(),
      "employees": employees?.map((e) => e.toJson()).toList(),
    };
  }

  Dummy copyWith({
    String? code,
    String? message,
    DummyData? data,
    DummyAlt? alt,
    bool? clockInFlag,
    bool? clockOutFlag,
    List<int>? ids,
    List<DummyEmployee>? employees,
  }) {
    return Dummy(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      alt: alt ?? this.alt,
      clockInFlag: clockInFlag ?? this.clockInFlag,
      clockOutFlag: clockOutFlag ?? this.clockOutFlag,
      ids: ids ?? this.ids,
      employees: employees ?? this.employees,
    );
  }

  @override
  List<Object?> get props {
    return [
      code,
      message,
      ...(data?.props ?? []),
      ...(alt?.props ?? []),
      clockInFlag,
      clockOutFlag,
      ...(ids ?? []).map((e) => [e]).expand((e) => e).toList(),
      ...(employees ?? []).map((e) => e.props).expand((e) => e).toList(),
    ];
  }
}

class DummyData extends Equatable {
  final DateTime? insertDate;
  final dynamic insertUser;
  final DateTime? updateDate;
  final dynamic updateUser;
  final dynamic deleteFlag;
  final dynamic deleteDate;
  final dynamic deleteUser;
  final int? activeFlg;
  final int? attendanceId;
  final int? shiftId;
  final int? employeeId;
  final bool? isNextDay;
  final bool? isClosed;
  final DateTime? clockIn;
  final dynamic clockOut;

  const DummyData({
    required this.insertDate,
    required this.insertUser,
    required this.updateDate,
    required this.updateUser,
    required this.deleteFlag,
    required this.deleteDate,
    required this.deleteUser,
    required this.activeFlg,
    required this.attendanceId,
    required this.shiftId,
    required this.employeeId,
    required this.isNextDay,
    required this.isClosed,
    required this.clockIn,
    required this.clockOut,
  });

  factory DummyData.fromJson(Map json) {
    return DummyData(
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      insertUser: json["insert_user"],
      updateDate: DateTime.tryParse(json["update_date"] ?? ""),
      updateUser: json["update_user"],
      deleteFlag: json["delete_flag"],
      deleteDate: json["delete_date"],
      deleteUser: json["delete_user"],
      activeFlg: json["active_flg"],
      attendanceId: json["attendance_id"],
      shiftId: json["shift_id"],
      employeeId: json["employee_id"],
      isNextDay: json["isNextDay"],
      isClosed: json["isClosed"],
      clockIn: DateTime.tryParse(json["clock_in"] ?? ""),
      clockOut: json["clock_out"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "insert_date": insertDate?.toIso8601String(),
      "insert_user": insertUser,
      "update_date": updateDate?.toIso8601String(),
      "update_user": updateUser,
      "delete_flag": deleteFlag,
      "delete_date": deleteDate,
      "delete_user": deleteUser,
      "active_flg": activeFlg,
      "attendance_id": attendanceId,
      "shift_id": shiftId,
      "employee_id": employeeId,
      "isNextDay": isNextDay,
      "isClosed": isClosed,
      "clock_in": clockIn?.toIso8601String(),
      "clock_out": clockOut,
    };
  }

  DummyData copyWith({
    DateTime? insertDate,
    dynamic insertUser,
    DateTime? updateDate,
    dynamic updateUser,
    dynamic deleteFlag,
    dynamic deleteDate,
    dynamic deleteUser,
    int? activeFlg,
    int? attendanceId,
    int? shiftId,
    int? employeeId,
    bool? isNextDay,
    bool? isClosed,
    DateTime? clockIn,
    dynamic clockOut,
  }) {
    return DummyData(
      insertDate: insertDate ?? this.insertDate,
      insertUser: insertUser ?? this.insertUser,
      updateDate: updateDate ?? this.updateDate,
      updateUser: updateUser ?? this.updateUser,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      deleteDate: deleteDate ?? this.deleteDate,
      deleteUser: deleteUser ?? this.deleteUser,
      activeFlg: activeFlg ?? this.activeFlg,
      attendanceId: attendanceId ?? this.attendanceId,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      isNextDay: isNextDay ?? this.isNextDay,
      isClosed: isClosed ?? this.isClosed,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }

  @override
  List<Object?> get props {
    return [
      insertDate?.toIso8601String(),
      insertUser,
      updateDate?.toIso8601String(),
      updateUser,
      deleteFlag,
      deleteDate,
      deleteUser,
      activeFlg,
      attendanceId,
      shiftId,
      employeeId,
      isNextDay,
      isClosed,
      clockIn?.toIso8601String(),
      clockOut,
    ];
  }
}

class DummyAlt extends Equatable {
  final DateTime? insertDate;
  final dynamic insertUser;
  final DateTime? updateDate;
  final dynamic updateUser;
  final dynamic deleteFlag;
  final dynamic deleteDate;
  final dynamic deleteUser;
  final int? activeFlg;
  final int? attendanceId;
  final int? shiftId;
  final int? employeeId;
  final bool? isNextDay;
  final bool? isClosed;
  final DateTime? clockIn;
  final dynamic clockOut;

  const DummyAlt({
    required this.insertDate,
    required this.insertUser,
    required this.updateDate,
    required this.updateUser,
    required this.deleteFlag,
    required this.deleteDate,
    required this.deleteUser,
    required this.activeFlg,
    required this.attendanceId,
    required this.shiftId,
    required this.employeeId,
    required this.isNextDay,
    required this.isClosed,
    required this.clockIn,
    required this.clockOut,
  });

  factory DummyAlt.fromJson(Map json) {
    return DummyAlt(
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      insertUser: json["insert_user"],
      updateDate: DateTime.tryParse(json["update_date"] ?? ""),
      updateUser: json["update_user"],
      deleteFlag: json["delete_flag"],
      deleteDate: json["delete_date"],
      deleteUser: json["delete_user"],
      activeFlg: json["active_flg"],
      attendanceId: json["attendance_id"],
      shiftId: json["shift_id"],
      employeeId: json["employee_id"],
      isNextDay: json["isNextDay"],
      isClosed: json["isClosed"],
      clockIn: DateTime.tryParse(json["clock_in"] ?? ""),
      clockOut: json["clock_out"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "insert_date": insertDate?.toIso8601String(),
      "insert_user": insertUser,
      "update_date": updateDate?.toIso8601String(),
      "update_user": updateUser,
      "delete_flag": deleteFlag,
      "delete_date": deleteDate,
      "delete_user": deleteUser,
      "active_flg": activeFlg,
      "attendance_id": attendanceId,
      "shift_id": shiftId,
      "employee_id": employeeId,
      "isNextDay": isNextDay,
      "isClosed": isClosed,
      "clock_in": clockIn?.toIso8601String(),
      "clock_out": clockOut,
    };
  }

  DummyAlt copyWith({
    DateTime? insertDate,
    dynamic insertUser,
    DateTime? updateDate,
    dynamic updateUser,
    dynamic deleteFlag,
    dynamic deleteDate,
    dynamic deleteUser,
    int? activeFlg,
    int? attendanceId,
    int? shiftId,
    int? employeeId,
    bool? isNextDay,
    bool? isClosed,
    DateTime? clockIn,
    dynamic clockOut,
  }) {
    return DummyAlt(
      insertDate: insertDate ?? this.insertDate,
      insertUser: insertUser ?? this.insertUser,
      updateDate: updateDate ?? this.updateDate,
      updateUser: updateUser ?? this.updateUser,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      deleteDate: deleteDate ?? this.deleteDate,
      deleteUser: deleteUser ?? this.deleteUser,
      activeFlg: activeFlg ?? this.activeFlg,
      attendanceId: attendanceId ?? this.attendanceId,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      isNextDay: isNextDay ?? this.isNextDay,
      isClosed: isClosed ?? this.isClosed,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }

  @override
  List<Object?> get props {
    return [
      insertDate?.toIso8601String(),
      insertUser,
      updateDate?.toIso8601String(),
      updateUser,
      deleteFlag,
      deleteDate,
      deleteUser,
      activeFlg,
      attendanceId,
      shiftId,
      employeeId,
      isNextDay,
      isClosed,
      clockIn?.toIso8601String(),
      clockOut,
    ];
  }
}

class DummyEmployee extends Equatable {
  final String? fullname;

  const DummyEmployee({
    required this.fullname,
  });

  factory DummyEmployee.fromJson(Map json) {
    return DummyEmployee(
      fullname: json["fullname"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
    };
  }

  DummyEmployee copyWith({
    String? fullname,
  }) {
    return DummyEmployee(
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  List<Object?> get props {
    return [
      fullname,
    ];
  }
}
