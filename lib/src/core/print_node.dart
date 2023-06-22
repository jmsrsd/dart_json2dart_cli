import 'parse_node.dart';

class PrintNode {
  final ParseNode node;

  PrintNode.of(this.node);

  @override
  String toString() {
    return node.classes
        .map((e) => [...e.writer.write(), ''])
        .expand((e) => e)
        .toList()
        .asMap()
        .entries
        .toList()
        .where((e) {
          return e.key == 0 || e.value.contains(r"import '") == false;
        })
        .map((e) => e.value)
        .join('\n');
  }
}
