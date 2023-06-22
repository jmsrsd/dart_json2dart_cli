enum ParseNodeType {
  object(
    label: 'class',
    childless: true,
  ),

  array(
    label: 'List',
    childless: true,
  ),

  date(
    label: 'DateTime',
    childless: false,
  ),

  string(
    label: 'String',
    childless: false,
  ),

  integer(
    label: 'int',
    childless: false,
  ),

  float(
    label: 'double',
    childless: false,
  ),

  boolean(
    label: 'bool',
    childless: false,
  ),

  unknown(
    label: 'dynamic',
    childless: false,
  );

  final String label;
  final bool childless;

  const ParseNodeType({
    required this.label,
    required this.childless,
  });

  factory ParseNodeType.of(dynamic node) {
    if (node is Map) {
      return object;
    } else if (node is List) {
      return array;
    } else if (node is String) {
      return DateTime.tryParse(node) != null ? date : string;
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
