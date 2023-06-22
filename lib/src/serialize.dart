import 'dart:convert';

Map<String, dynamic>? serialize(dynamic json) {
  try {
    final serialized = jsonDecode(jsonEncode(json)) as Map;

    final entries = serialized.entries.map((e) {
      return MapEntry('${e.key}', e.value);
    }).toList();

    return Map.fromEntries(entries);
  } catch (e) {
    return null;
  }
}
