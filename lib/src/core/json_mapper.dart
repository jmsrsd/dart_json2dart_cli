import 'dart:convert';

import '../util/prettify.dart';
import 'json_code.dart';
import 'json_node.dart';
import 'json_type.dart';

class JsonMapper {
  final JsonNode node;

  const JsonMapper.of(this.node);

  List<JsonNode> flatten([List<JsonNode>? list]) {
    var result = list ?? <JsonNode>[];

    result.add(node);

    for (final child in node.children) {
      result = JsonMapper.of(child).flatten(result);
    }

    return result;
  }

  List<JsonNode> get classes {
    return flatten().where((e) {
      return e.type == JsonType.object;
    }).toList();
  }

  String get code {
    final result = classes
        .map((e) => JsonCode.of(e).toString())
        .map((e) => e.split('\n'))
        .expand((e) => e)
        .toList()
        .asMap()
        .entries
        .where((e) {
          return e.key == 0 ? true : e.value.startsWith('import') == false;
        })
        .map((e) => e.value.trimRight())
        .toList();

    return result.join('\n');
  }
}
