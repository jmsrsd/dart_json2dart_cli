import 'dart:convert';

import 'package:recase/recase.dart';

import '../util/pluralize/pluralize.dart';
import '../util/prettify.dart';
import 'json_type.dart';

class JsonNode {
  final dynamic source;
  final JsonNode? parent;
  final String name;

  const JsonNode({
    required this.source,
    required this.parent,
    required this.name,
  });

  factory JsonNode.root(dynamic source) {
    return JsonNode(
      source: source,
      parent: null,
      name: r'Root$',
    );
  }

  List<JsonNode> get ancestors {
    final result = <JsonNode>[];

    var selected = parent;

    do {
      if (selected != null) {
        result.add(selected);
      }

      selected = selected?.parent;
    } while (selected != null);

    return result;
  }

  String get classname {
    if (type != JsonType.object) {
      return type.name;
    }

    final prefix = ancestors.reversed.where((e) {
      return e.type != JsonType.array;
    }).map((e) {
      return e.label;
    }).join();

    return '$prefix$label';
  }

  String get fullname {
    return [
      parent?.fullname,
      label,
    ].where((e) {
      return e != null;
    }).join('.');
  }

  String get label {
    return type == JsonType.object ? name.pascalCase : name.camelCase;
  }

  JsonType get type {
    return JsonType.of(source);
  }

  List<JsonNode> get children {
    if (type == JsonType.object) {
      return (source as Map).entries.map((e) {
        return JsonNode(
          source: e.value,
          parent: this,
          name: e.key,
        );
      }).toList();
    }

    if (type == JsonType.array) {
      final child = (source as List).first;
      return [
        JsonNode(
          source: child,
          parent: this,
          name: Pluralize().singular(name),
        ),
      ];
    }

    return [];
  }

  dynamic fullencode() {
    if (type == JsonType.object) {
      return Map.fromEntries(
        children.map((e) {
          return MapEntry(e.label, e.fullencode());
        }).toList(),
      );
    }

    if (type == JsonType.array) {
      final child = children.first;
      return [child.type.childless ? child.type.name : child.fullencode()];
    }

    return type.name;
  }

  dynamic encode() {
    if (type == JsonType.object) {
      return Map.fromEntries(
        children.map((e) {
          return MapEntry(
            e.label.camelCase,
            e.type == JsonType.object ? e.classname : e.type.name,
          );
        }).toList(),
      );
    }

    if (type == JsonType.array) {
      final child = children.first;
      return [child.type.childless ? child.type.name : child.encode()];
    }

    return type == JsonType.object ? label.pascalCase : type.name;
  }

  @override
  String toString() {
    return prettify(jsonEncode(fullencode()));
  }
}
