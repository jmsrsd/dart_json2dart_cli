import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../util/prettify.dart';
import '../util/pluralize/pluralize.dart';
import 'parse_node_type.dart';
import 'write_node.dart';
import 'package:recase/recase.dart';

class ParseNode extends Equatable {
  final dynamic json;
  final String? name;
  final ParseNodeType type;
  final ParseNode? parent;
  final List<ParseNode> children;
  final List<ParseNode> elements;

  int get id {
    return elements.indexOf(this);
  }

  ParseNode get root {
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

  List<ParseNode> get classes {
    return elements.where((e) {
      return e.type == ParseNodeType.object;
    }).map((e) {
      final parent = e.parent;

      final parentName = parent?.type == ParseNodeType.object
          ? parent?.name?.pascalCase ?? r'Root$'
          : '';

      final name = '$parentName${e.name?.pascalCase ?? r'Root$'}';

      return ParseNode.root(
        e.json,
        name: name,
      );
    }).toList();
  }

  WriteNode get writer {
    return WriteNode.of(this);
  }

  ParseNode({
    required this.json,
    required this.name,
    required this.type,
    required this.parent,
    required this.children,
    required this.elements,
  }) {
    elements.add(this);
  }

  factory ParseNode.root(dynamic json, {String? name}) {
    return ParseNode.parse(
      json,
      name: name,
      parent: null,
      elements: null,
    );
  }

  factory ParseNode.parse(
    dynamic json, {
    required String? name,
    required ParseNode? parent,
    required List<ParseNode>? elements,
  }) {
    final self = ParseNode(
      json: json,
      type: ParseNodeType.of(json),
      name: name,
      parent: parent,
      children: [],
      elements: elements ?? [],
    );

    switch (self.type) {
      case ParseNodeType.object:
        final source = json as Map;

        self.children.addAll(
          source.entries.map((e) {
            return ParseNode.parse(
              e.value,
              name: e.key,
              parent: self,
              elements: self.elements,
            );
          }).toList(),
        );
      case ParseNodeType.array:
        final source = json as List;

        if (source.isEmpty) {
          return self.copyWith(
            type: ParseNodeType.unknown,
          );
        }

        self.children.add(
          ParseNode.parse(
            source.first,
            name: Pluralize().singular(name!),
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

  ParseNode copyWith({
    dynamic json,
    String? name,
    ParseNodeType? type,
    ParseNode? parent,
    List<ParseNode>? children,
    List<ParseNode>? elements,
  }) {
    return ParseNode(
      json: json ?? this.json,
      name: name ?? this.name,
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
    final result = [
      '$name:${type.name}',
      ...children.map((e) => '${e.name}:${e.type.name}').toList(),
    ];

    print(result);

    return result;
  }
}
