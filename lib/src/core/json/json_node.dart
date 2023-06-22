import 'dart:convert';

import '../../util/pluralize/pluralize.dart';
import '../../util/prettify.dart';
import 'src/object_json_node.dart';

abstract class JsonNode {
  final String name;
  final dynamic source;
  final JsonNode? parent;
  final List<JsonNode> children;

  String get type;

  JsonNode? get child => children.firstOrNull;

  bool get childless => children.isEmpty;

  JsonNode(this.name, this.source, this.parent, this.children);

  factory JsonNode.parse(
    String name,
    dynamic source, [
    JsonNode? parent,
  ]) {
    if (source is Map) {
      return ObjectJsonNode.parse(name, source, parent);
    }

    if (source is List) {
      return ArrayJsonNode.parse(name, source, parent);
    }

    if (source is String) {
      return DateTime.tryParse(source) != null
          ? DateTimeJsonNode(name, source, parent, [])
          : StringJsonNode(name, source, parent, []);
    }

    if (source is int) {
      return IntegerJsonNode(name, source, parent, []);
    }

    if (source is double) {
      return FloatJsonNode(name, source, parent, []);
    }

    if (source is bool) {
      return BooleanJsonNode(name, source, parent, []);
    }

    return UnknownJsonNode(name, source, parent, []);
  }

  Map<String, dynamic> decode() {
    return Map.fromEntries([
      if (parent != null) MapEntry('parent', parent?.name),
      MapEntry('name', name),
      MapEntry('type', type),
      if (children.length > 1)
        MapEntry('children', children.map((e) => e.decode()).toList()),
      if (children.length == 1) MapEntry('child', child?.decode()),
    ]);
  }

  @override
  String toString() {
    return prettify(jsonEncode(decode()));
  }
}

class ArrayJsonNode extends JsonNode {
  ArrayJsonNode(super.name, super.source, super.parent, super.children);

  static JsonNode parse(
    String name,
    List source, [
    JsonNode? parent,
  ]) {
    if (source.isEmpty) {
      return UnknownJsonNode(name, source, parent, []);
    }

    final self = ArrayJsonNode(
      name,
      source,
      parent,
      [],
    );

    self.children.addAll(
      [source.first].map((e) {
        return JsonNode.parse(
          Pluralize().singular(name),
          e,
          self,
        );
      }).toList(),
    );

    return self;
  }

  @override
  String get type => 'Array';
}

class DateTimeJsonNode extends JsonNode {
  DateTimeJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'DateTime';
}

class StringJsonNode extends JsonNode {
  StringJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'String';
}

class IntegerJsonNode extends JsonNode {
  IntegerJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'Integer';
}

class FloatJsonNode extends JsonNode {
  FloatJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'Integer';
}

class BooleanJsonNode extends JsonNode {
  BooleanJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'Boolean';
}

class UnknownJsonNode extends JsonNode {
  UnknownJsonNode(super.name, super.source, super.parent, super.children);

  @override
  String get type => 'Unknown';
}
