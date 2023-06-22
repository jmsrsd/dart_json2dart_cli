import 'package:recase/recase.dart';
import '../json_node.dart';

class ObjectJsonNode extends JsonNode {
  ObjectJsonNode(
    super.name,
    super.source,
    super.parent,
    super.children,
  );

  @override
  String get type => 'Object';

  static JsonNode parse(
    String name,
    Map source, [
    JsonNode? parent,
  ]) {
    final self = ObjectJsonNode(
      name,
      source,
      parent,
      [],
    );

    final children = source.entries.map((e) {
      return JsonNode.parse(
        e.key,
        e.value,
        self,
      );
    }).map((e) {
      if (e is ObjectJsonNode) {
        return JsonNode.parse(
          '${name.pascalCase}${e.name.pascalCase}'.pascalCase,
          e.source,
          self,
        );
      }

      if (e is ArrayJsonNode) {
        final child = e.child;

        if (child is ObjectJsonNode) {
          e.children.clear();
          e.children.add(
            JsonNode.parse(
              '${name.pascalCase}${child.name.pascalCase}'.pascalCase,
              child.source,
              e,
            ),
          );
        }

        return e;
      }

      return e;
    }).toList();

    self.children.addAll(children);

    return self;
  }
}
