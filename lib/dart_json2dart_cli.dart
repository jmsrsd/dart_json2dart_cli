import 'dart:convert';

import 'src/core/json_mapper.dart';
import 'src/core/json_node.dart';
import 'src/dummy.dart';
import 'src/util/prettify.dart';

Future<void> execute(List<String> arguments) async {
  // for (final argument in arguments) {
  //   print(argument);
  // }

  final json = {
    "code": "0",
    "message": "Success",
    "data": {
      "insert_date": "2023-06-19T12:18:30.519Z",
      "insert_user": null,
      "update_date": "2023-06-20T07:13:56.285Z",
      "update_user": null,
      "delete_flag": null,
      "delete_date": null,
      "delete_user": null,
      "active_flg": 1,
      "attendance_id": 36,
      "shift_id": 14,
      "employee_id": 1212,
      "isNextDay": true,
      "isClosed": false,
      "clock_in": "2023-06-19T12:18:30.519Z",
      "clock_out": null
    },
    "alt": {
      "insert_date": "2023-06-19T12:18:30.519Z",
      "insert_user": null,
      "update_date": "2023-06-20T07:13:56.285Z",
      "update_user": null,
      "delete_flag": null,
      "delete_date": null,
      "delete_user": null,
      "active_flg": 1,
      "attendance_id": 36,
      "shift_id": 14,
      "employee_id": 1212,
      "isNextDay": true,
      "isClosed": false,
      "clock_in": "2023-06-19T12:18:30.519Z",
      "clock_out": null
    },
    "clock_in_flag": false,
    "clock_out_flag": false,
    "ids": [123, 456, 789],
    "employees": [
      {
        "fullname": "Budi Budianto",
      }
    ],
  };

  final node = JsonNode.root(json);

  final mapper = JsonMapper.of(node);

  print(mapper.code);

  // print(prettify(jsonEncode(Dummy.fromJson(json).toJson())));
}
