import 'package:equatable/equatable.dart';

class Root$ extends Equatable {
  final String? code;
  final String? message;
  final Data? data;
  final Alt? alt;
  final bool? clockInFlag;
  final bool? clockOutFlag;
  final List<int>? ids;
  final List<Employee>? employees;

  const Root$({
    required this.code,
    required this.message,
    required this.data,
    required this.alt,
    required this.clockInFlag,
    required this.clockOutFlag,
    required this.ids,
    required this.employees,
  });

  factory Root$.fromJson(Map json) {
    return Root$(
      code: json["code"],
      message: json["message"],
      data: Data.fromJson(json["data"] ?? {}),
      alt: Alt.fromJson(json["alt"] ?? {}),
      clockInFlag: json["clock_in_flag"],
      clockOutFlag: json["clock_out_flag"],
      ids: (json["ids"] ?? []).map((e) => e as int).toList(),
      employees:
          (json["employees"] ?? []).map((e) => Employee.fromJson(e)).toList(),
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
      "ids": ids,
      "employees": employees?.map((e) => e.toJson()).toList(),
    };
  }

  Root$ copyWith({
    String? code,
    String? message,
    Data? data,
    Alt? alt,
    bool? clockInFlag,
    bool? clockOutFlag,
    List<int>? ids,
    List<Employee>? employees,
  }) {
    return Root$(
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
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      code,
      message,
      data,
      alt,
      clockInFlag,
      clockOutFlag,
      ...(ids ?? []),
      ...(employees ?? []),
    ];
  }
}

class Data extends Equatable {
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

  const Data({
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

  factory Data.fromJson(Map json) {
    return Data(
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

  Data copyWith({
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
    return Data(
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
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      insertDate,
      insertUser,
      updateDate,
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
      clockIn,
      clockOut,
    ];
  }
}

class Alt extends Equatable {
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

  const Alt({
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

  factory Alt.fromJson(Map json) {
    return Alt(
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

  Alt copyWith({
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
    return Alt(
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
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      insertDate,
      insertUser,
      updateDate,
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
      clockIn,
      clockOut,
    ];
  }
}

class Employee extends Equatable {
  final String? fullname;

  const Employee({
    required this.fullname,
  });

  factory Employee.fromJson(Map json) {
    return Employee(
      fullname: json["fullname"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
    };
  }

  Employee copyWith({
    String? fullname,
  }) {
    return Employee(
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      fullname,
    ];
  }
}
