import 'dart:convert';

import 'package:recase/recase.dart';

import '../util/prettify.dart';
import 'json_node.dart';
import 'json_type.dart';

class JsonCode {
  final JsonNode node;

  const JsonCode.of(this.node);

  List<String> get properties {
    return node.children.map((e) {
      return 'final ${JsonCode.of(e).property};';
    }).toList();
  }

  String get property {
    late final String type;

    switch (node.type) {
      case JsonType.object:
        type = node.classname;
        break;
      case JsonType.array:
        final child = node.children.first;
        final childType =
            child.type == JsonType.object ? child.classname : child.type.label;

        type = 'List<$childType>';
        break;
      default:
        type = node.type.label;
        break;
    }

    final isDynamic = node.type == JsonType.unknown;

    return '$type' '${isDynamic ? '' : '?'}' ' ${node.name.camelCase}';
  }

  List<String> get constructorBlock {
    if (node.type == JsonType.object) {
      return [
        'const ${node.classname}({',
        ...node.children.map((e) {
          return JsonCode.of(e);
        }).map((e) {
          return e.contructorField;
          // return e.from;
        }).map((e) {
          return '  $e';
        }).toList(),
        '});',
      ];
    }

    return [];
  }

  String get contructorField {
    final key = node.name.camelCase;

    return 'required this.$key,';
  }

  List<String> get fromJsonBlock {
    return [
      'factory ${node.classname}.fromJson(Map json) {',
      '  return ${node.classname}(',
      ...node.children.map((e) {
        return '    ${JsonCode.of(e).fromJsonField}';
      }).toList(),
      '  );',
      '}',
    ];
  }

  String get fromJsonField {
    final key = node.name.camelCase;
    final value = 'json["${node.name}"]';

    if (node.type == JsonType.object) {
      return '$key: ${node.classname}.fromJson($value ?? {}),';
    }

    if (node.type == JsonType.array) {
      final child = node.children.first;

      late final String childValue;

      switch (child.type) {
        case JsonType.object:
          childValue = '${child.classname}.fromJson(e)';
          break;
        case JsonType.datetime:
          childValue = 'DateTime.tryParse(e)';
          break;
        default:
          childValue = 'e as ${child.type.label}';
          break;
      }

      return '$key: ($value as List?)?.map((e) => $childValue).toList(),';
    }

    if (node.type == JsonType.datetime) {
      return '$key: DateTime.tryParse($value ?? ""),';
    }

    return '$key: $value,';
  }

  List<String> get toJsonBlock {
    return [
      'Map<String, dynamic> toJson() {',
      '  return {',
      ...node.children.map((e) {
        return '    ${JsonCode.of(e).toJsonField}';
      }).toList(),
      '  };',
      '}',
    ];
  }

  String get toJsonField {
    final key = node.name;
    late final String value;

    switch (node.type) {
      case JsonType.object:
        value = '${node.name.camelCase}?.toJson()';
        break;
      case JsonType.array:
        final child = node.children.first;
        late final String childValue;

        switch (child.type) {
          case JsonType.object:
            childValue = 'e.toJson()';
            break;
          case JsonType.datetime:
            childValue = 'e.toIso8601String()';
            break;
          default:
            childValue = 'e';
            break;
        }
        value = '${node.name.camelCase}?'
            '.map((e) => $childValue)'
            '.toList()';
        break;
      case JsonType.datetime:
        value = '${node.name.camelCase}?.toIso8601String()';
        break;
      default:
        value = node.name.camelCase;
        break;
    }

    return '"$key": $value,';
  }

  List<String> get propsBlock {
    return [
      '@override',
      'List<Object?> get props {',
      '  return [',
      ...node.children.map((e) {
        return '    ${JsonCode.of(e).propsField},';
      }).toList(),
      '  ];',
      '}',
    ];
  }

  String get propsField {
    final name = node.name.camelCase;
    final type = node.type;

    switch (type) {
      case JsonType.object:
        return '...($name?.props ?? [])';
      case JsonType.array:
        final child = node.children.first;
        final childType = child.type;
        late final String childValue;

        switch (childType) {
          case JsonType.object:
            childValue = 'e.props';
            break;
          case JsonType.datetime:
            childValue = '[e.toIso8601String()]';
            break;
          default:
            childValue = '[e]';
            break;
        }

        return '...($name ?? []).map((e) => $childValue).expand((e) => e).toList()';
      case JsonType.datetime:
        return '$name?.toIso8601String()';
      default:
        return name;
    }
  }

  List<String> get copyWithBlock {
    if (node.type == JsonType.object) {
      return [
        '${node.classname} copyWith({',
        ...node.children.map((e) {
          return JsonCode.of(e);
        }).map((e) {
          return e.copyWithField;
          // return e.from;
        }).map((e) {
          return '  $e';
        }).toList(),
        '}) {',
        '  return ${node.classname}(',
        ...node.children.map((e) => e.name.camelCase).map((e) {
          return '    $e: $e ?? this.$e,';
        }).toList(),
        '  );',
        '}',
      ];
    }

    return [];
  }

  String get copyWithField {
    final name = node.name.camelCase;

    late final String type;

    switch (node.type) {
      case JsonType.object:
        type = node.classname;
        break;
      case JsonType.array:
        final child = node.children.first;
        late final String childType;

        switch (child.type) {
          case JsonType.object:
            childType = child.classname;
            break;
          default:
            childType = child.type.label;
            break;
        }

        type = 'List<$childType>';

      default:
        type = node.type.label;
        break;
    }

    final isDynamic = node.type == JsonType.unknown;

    return '$type' '${isDynamic ? '' : '?'}' ' $name,';
  }

  @override
  String toString() {
    return [
      r"import 'package:equatable/equatable.dart';",
      '',
      ...[
        r'/// Example:',
        r'/// ',
      ],
      ...(prettify(jsonEncode(node.source)))
          .split('\n')
          .map((e) => r'/// ' '$e')
          .toList(),
      'class ${node.classname} extends Equatable {',
      ...properties.map((e) => '  $e').toList(),
      '',
      ...constructorBlock.map((e) => '  $e').toList(),
      '',
      ...fromJsonBlock.map((e) => '  $e').toList(),
      '',
      ...toJsonBlock.map((e) => '  $e').toList(),
      '',
      ...copyWithBlock.map((e) => '  $e').toList(),
      '',
      ...propsBlock.map((e) => '  $e').toList(),
      '}',
    ].join('\n');
  }
}
