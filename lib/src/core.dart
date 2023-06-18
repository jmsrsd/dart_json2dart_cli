// ignore_for_file: empty_catches

import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:recase/recase.dart';

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

Type getCastedType<T>(dynamic value) {
  try {
    if (value is T) {
      return T;
    }
  } catch (e) {}

  return dynamic;
}

Type getType(dynamic value) {
  return {
    getCastedType<double>(value),
    getCastedType<int>(value),
    getCastedType<String>(value),
    getCastedType<Map>(value),
    getCastedType<List>(value),
  }.toList().firstWhere(
    (e) {
      return '$e' != 'dynamic';
    },
    orElse: () => dynamic,
  );
}

final tokens = <String>[];

String tokenize(dynamic value) {
  final type = getType(value);

  late final String result;

  switch (type) {
    case Map:
      final map = (value as Map).map((k, v) {
        tokens.add(tokenize(v));

        return MapEntry(
          '$k'.camelCase,
          '${tokens.length - 1}',
        );
      });

      tokens.add(jsonEncode(map));

      result = 'Map<${tokens.length - 1}>';
      break;
    case List:
      final list = value as List;
      final element = list.isNotEmpty ? list.first : null;

      tokens.add(tokenize(element));

      result = 'List<${tokens.length - 1}>';
      break;
    default:
      result = type.toString();
      break;
  }

  return result;
}

final classes = <String, String>{};

String convert(String token) {
  if (tokens.contains(token) == false) {
    tokens.add(token);
  }

  if (token.contains('Map<')) {
    final index = tokens
        .asMap()
        .entries
        .map((e) {
          return MapEntry(e.value, e.key);
        })
        .firstWhere((e) => e.key == token)
        .value;

    final body = token
        .trim()
        .replaceAll('<', ' ')
        .replaceAll('>', '')
        .split(' ')
        .last
        .trim();

    final content = convert(tokens[int.parse(body)]);

    token = [
      'class _$index {',
      content,
      '}',
    ].join('\n');

    classes['_$index'] = token;

    return token;
  }

  if (token.contains('{')) {
    final json = serialize(jsonDecode(token)) ?? {};

    return json.entries.map((e) {
      var content = convert(tokens[int.parse(e.value)]);

      if (content.contains('class _')) {
        content = content.split(' ')[1];
      }

      return '  ' 'final $content? ${e.key};';
    }).join('\n');
  }

  if (token.contains('List<')) {
    final body = token
        .trim()
        .replaceAll('<', ' ')
        .replaceAll('>', '')
        .split(' ')
        .last
        .trim();

    var content = convert(tokens[int.parse(body)]);

    if (content.contains('class _')) {
      content = content.split(' ')[1];
    }

    token = [
      'List<',
      content,
      '>',
    ].join('');

    return token;
  }

  // return classes.values.join('\n\n');

  return token;
}

String createConstructor(String name, String properties) {
  final initial = properties.split('\n');

  var lines = initial.toList();

  lines[0] = 'factory $name.fromJson(Map<String, dynamic> json) {';

  for (var i = 1; i < lines.length - 1; i++) {
    lines[i] = lines[i].trim().split(' ').last.replaceFirst(';', '');
    lines[i] = '${lines[i]}: json["${lines[i].snakeCase}"],';
  }

  lines = [
    initial[0].replaceFirst('class ', 'const ').replaceFirst(' {', '({'),
    ...lines.sublist(1, lines.length - 1).map((e) {
      return [
        '  this.$e'.split(':').first,
        ',',
      ].join('');
    }).toList(),
    '});',
  ];

  return lines.join('\n');
}

String createCopyWith(String name, String properties) {
  final initial = properties.split('\n');

  print('--- INITIAL ---');
  for (final line in initial) {
    print(line);
  }

  final constructor = createConstructor(name, properties).split('\n');

  var lines = constructor.toList();

  lines[0] = lines[0].replaceFirst('const ', '');
  lines[0] = lines[0].replaceFirst('({', ' copyWith({');

  lines = [
    lines[0],
    ...initial.sublist(1, initial.length - 1).map((e) {
      e = e.replaceFirst('final ', '');
      e = e.replaceFirst(';', ',');
      return e;
    }),
    lines[lines.length - 1],
  ];

  final fromJson = createFromJsonFactory(name, properties).split('\n');
  final body = fromJson.sublist(1, fromJson.length - 1);

  lines[lines.length - 1] = lines[lines.length - 1].replaceFirst(';', ' {');
  lines.addAll(body.map((e) {
    if (e.contains(':') == false) {
      return e;
    }

    final name = e.split(':').first.trim();

    return '    $name: $name ?? this.$name,';
  }).toList());
  lines.add('}');

  return lines.join('\n');
}

String createFromJsonFactory(String name, String properties) {
  final initial = properties.split('\n');

  var lines = initial.toList();

  lines[0] = 'factory $name.fromJson(Map<String, dynamic> json) {';

  for (var i = 1; i < lines.length - 1; i++) {
    lines[i] = lines[i].trim().split(' ').last.replaceFirst(';', '');
    lines[i] = '${lines[i]}: json["${lines[i].snakeCase}"],';
  }

  lines = [
    lines[0],
    '  return ${initial[0].replaceFirst('class ', '').replaceFirst(' {', '(')}',
    ...lines.sublist(1, lines.length - 1).map((e) {
      return '    $e';
    }).toList(),
    '  );',
    '}',
  ];

  return lines.join('\n');
}

String createToJsonFactory(String name, String properties) {
  final initial = properties.split('\n');

  var lines = initial.toList();

  lines[0] = 'Map<String, dynamic> toJson() {';

  for (var i = 1; i < lines.length - 1; i++) {
    lines[i] = lines[i].trim().split(' ').last.replaceFirst(';', '');
    lines[i] = '${lines[i]}: json["${lines[i].snakeCase}"],';
  }

  lines = [
    lines[0],
    '  return {',
    ...lines.sublist(1, lines.length - 1).map((e) {
      final reversed =
          e.split(': ').map((e) => e.trim()).toList().reversed.toList();
      reversed[0] = reversed[0].replaceFirst(',', '');
      reversed[0] = reversed[0].replaceFirst('json[', '');
      reversed[0] = reversed[0].replaceFirst(']', '');
      return '    ${reversed.join(': ')},';
    }).toList(),
    '  };',
    '}',
  ];

  return lines.join('\n');
}
