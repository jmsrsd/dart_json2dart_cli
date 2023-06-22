import 'package:equatable/equatable.dart';
import 'package:recase/recase.dart';

import 'parse_node.dart';
import 'parse_node_type.dart';

class WriteNode extends Equatable {
  final ParseNode node;

  WriteNode.of(this.node);

  String get name {
    final result = node.name ?? r'Root$';
    return node.type == ParseNodeType.object
        ? result.pascalCase
        : result.camelCase;
  }

  String get asClassProperty {
    final label = name.camelCase;

    var type =
        node.type == ParseNodeType.object ? label.pascalCase : node.type.label;

    if (node.type == ParseNodeType.array) {
      final child = node.children.first;

      final childType = child.type == ParseNodeType.object
          ? WriteNode.of(child).name.pascalCase
          : child.type.label;

      return 'final $type<$childType>? $label;';
    }

    if (node.type != ParseNodeType.unknown) {
      type = '$type?';
    }

    return 'final $type $label;';
  }

  String get asConstructorArgument {
    return 'required this.${name.camelCase},';
  }

  String get asFromJsonProperty {
    var value = 'json["${node.name}"]';

    switch (node.type) {
      case ParseNodeType.object:
        value = '$name.fromJson($value ?? {})';
        break;
      case ParseNodeType.date:
        value = 'DateTime.tryParse($value ?? "")';
        break;
      case ParseNodeType.array:
        final child = WriteNode.of(node.children.first);

        final mapper = child.node.type == ParseNodeType.object
            ? '${child.name}.fromJson(e)'
            : 'e as ${child.node.type.label}';

        value = '($value ?? []).map((e) => $mapper).toList()';
        break;
      default:
        break;
    }

    return '${name.camelCase}: $value,';
  }

  String get asToJsonProperty {
    var value = name.camelCase;

    switch (node.type) {
      case ParseNodeType.object:
        value = '$value?.toJson()';
        break;
      case ParseNodeType.date:
        value = '$value?.toIso8601String()';
        break;
      case ParseNodeType.array:
        final child = WriteNode.of(node.children.first);

        if (child.node.type == ParseNodeType.object) {
          value = '$value?.map((e) => e.toJson()).toList()';
          break;
        }

        if (child.node.type == ParseNodeType.date) {
          value = '$value?.map((e) => e.toIso8601String()).toList()';
          break;
        }

        break;
      default:
        break;
    }

    return '"${node.name}": $value,';
  }

  List<String> write({WriteNode? child}) {
    if (node.type.childless) {
      child = null;
    }

    final result = <String>[];

    switch (node.type) {
      case ParseNodeType.object:
        if (node.parent != null) {
          return result..add(asClassProperty);
        }

        final children = node.children.map((e) {
          return WriteNode.of(e);
        }).toList();

        final properties =
            children.map((e) => e.write()).expand((e) => e).toList();

        result.addAll([
          r"import 'package:equatable/equatable.dart';",
          '',
          '${node.type.label} $name extends Equatable {',
          ...properties.map((e) => '  $e').toList(),
          '  ',
          '  const $name({',
          ...children.map((e) => '    ${e.asConstructorArgument}').toList(),
          '  });',
          '  ',
          '  factory $name.fromJson(Map json) {',
          '    return $name(',
          ...children.map((e) => '      ${e.asFromJsonProperty}').toList(),
          '    );',
          '  }',
          '  ',
          '  Map<String, dynamic> toJson() {',
          '    return {',
          ...children.map((e) => '      ${e.asToJsonProperty}').toList(),
          '    };',
          '  }',
          '  ',
          '  @override',
          '  List<Object?> get props {',
          '    return [',
          ...node.children.map((e) {
            if (e.type == ParseNodeType.array) {
              return '      ...(${e.name?.camelCase} ?? []),';
            }

            return '      ${e.name?.camelCase},';
          }).toList(),
          '    ];',
          '  }',
          '}',
        ]);
        break;
      default:
        result.add(asClassProperty);
        break;
    }

    return result;
  }

  @override
  List<Object?> get props {
    return node.props;
  }
}
