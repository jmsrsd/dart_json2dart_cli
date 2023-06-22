import 'dart:convert';

String encode(dynamic value) {
  return value is String ? value : jsonEncode(value);
}
