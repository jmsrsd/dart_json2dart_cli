import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:recase/recase.dart';

import 'prettify.dart';
import 'pluralize/pluralize.dart';

enum PropNodeType {
  string('String', false),
  integer('int', false),
  float('double', false),
  boolean('bool', false),
  object('class', true),
  array('List', true),
  unknown('dynamic', false);

  final String label;
  final bool childless;

  const PropNodeType(this.label, this.childless);

  factory PropNodeType.of(dynamic node) {
    if (node is Map) {
      return object;
    } else if (node is List) {
      return array;
    } else if (node is String) {
      return string;
    } else if (node is bool) {
      return boolean;
    } else if (node is double) {
      return float;
    } else if (node is int) {
      return integer;
    }

    return unknown;
  }
}

class PropNode extends Equatable {
  final String? sourceName;
  final PropNodeType type;
  final PropNode? parent;
  final List<PropNode> children;
  final List<PropNode> elements;

  String get name {
    final result = sourceName ?? r"$";
    return type == PropNodeType.object ? result.pascalCase : result.camelCase;
  }

  int get id {
    return elements.indexOf(this);
  }

  PropNode get root {
    var selected = this;

    while (selected.parent != null) {
      selected = selected.parent!;
    }

    return selected;
  }

  int get indent {
    final indents = List.generate(id + 1, (index) => 0);

    for (var i = 0; i <= id; i++) {
      if (elements[i].parent == null) {
        continue;
      }

      indents[i] = indents[elements[i].parent!.id] + 4;
    }

    return indents[id];
  }

  PropNode({
    required this.sourceName,
    required this.type,
    required this.parent,
    required this.children,
    required this.elements,
  });

  factory PropNode.parse(
    dynamic node, {
    required String? sourceName,
    required PropNode? parent,
    required List<PropNode>? elements,
  }) {
    final self = PropNode(
      type: PropNodeType.of(node),
      sourceName: sourceName,
      parent: parent,
      children: [],
      elements: elements ?? [],
    );

    self.elements.add(self);

    switch (self.type) {
      case PropNodeType.object:
        final source = node as Map;

        self.children.addAll(
          source.entries.map((e) {
            return PropNode.parse(
              e.value,
              sourceName: e.key,
              parent: self,
              elements: self.elements,
            );
          }).toList(),
        );
      case PropNodeType.array:
        final source = node as List;

        if (source.isEmpty) {
          return self.copyWith(
            type: PropNodeType.unknown,
          );
        }

        self.children.add(
          PropNode.parse(
            source.first,
            sourceName: Pluralize().singular(sourceName!),
            parent: self,
            elements: self.elements,
          ),
        );
        break;
      default:
        break;
    }

    return self;
  }

  PropNode copyWith({
    String? sourceName,
    PropNodeType? type,
    PropNode? parent,
    List<PropNode>? children,
    List<PropNode>? elements,
  }) {
    return PropNode(
      sourceName: sourceName ?? this.sourceName,
      type: type ?? this.type,
      parent: parent ?? this.parent,
      children: children ?? this.children,
      elements: elements ?? this.elements,
    );
  }

  Map<String, dynamic> toJson() {
    final result = {
      "id": id,
      "parent": parent?.id,
      "name": name,
      "type": type.name,
      "children": children.map((e) {
        return e.toJson();
      }).toList(),
    };

    if (children.isEmpty) {
      result.remove("children");
    }

    if (parent == null) {
      result.remove("parent");
    }

    return result;
  }

  @override
  String toString() {
    return prettify(jsonEncode(toJson()));
  }

  @override
  List<Object?> get props {
    return [
      name,
      parent?.name,
      type.name,
      ...children,
    ];
  }
}
