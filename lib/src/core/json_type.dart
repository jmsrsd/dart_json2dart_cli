enum JsonType {
  object,
  array,
  string,
  datetime,
  integer,
  float,
  boolean,
  unknown;

  factory JsonType.of(dynamic source) {
    if (source is Map) {
      return source.isEmpty ? unknown : object;
    }

    if (source is List) {
      return source.isEmpty ? unknown : array;
    }

    if (source is String) {
      return DateTime.tryParse(source) == null ? string : datetime;
    }

    if (source is int) {
      return integer;
    }

    if (source is double) {
      return float;
    }

    if (source is bool) {
      return boolean;
    }

    return unknown;
  }

  bool get childless {
    return [object, array].contains(this) == false;
  }

  String get label {
    switch (this) {
      case object:
        return 'class';
      case array:
        return 'List';
      case string:
        return 'String';
      case datetime:
        return 'DateTime';
      case integer:
        return 'int';
      case float:
        return 'double';
      case boolean:
        return 'bool';
      default:
        return 'dynamic';
    }
  }
}
