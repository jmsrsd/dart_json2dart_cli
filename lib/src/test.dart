class _17 {
  final String? by;
  final int? descendants;
  final int? id;
  final _6? kids;
  final List<_9>? parent;
  final int? score;
  final int? time;
  final String? title;
  final String? type;
  final String? url;

  const _17({
    this.by,
    this.descendants,
    this.id,
    this.kids,
    this.parent,
    this.score,
    this.time,
    this.title,
    this.type,
    this.url,
  });

  _17 copyWith({
    String? by,
    int? descendants,
    int? id,
    _6? kids,
    List<_9>? parent,
    int? score,
    int? time,
    String? title,
    String? type,
    String? url,
  }) {
    return _17(
      by: by ?? this.by,
      descendants: descendants ?? this.descendants,
      id: id ?? this.id,
      kids: kids ?? this.kids,
      parent: parent ?? this.parent,
      score: score ?? this.score,
      time: time ?? this.time,
      title: title ?? this.title,
      type: type ?? this.type,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "by": by,
      "descendants": descendants,
      "id": id,
      "kids": kids,
      "parent": parent,
      "score": score,
      "time": time,
      "title": title,
      "type": type,
      "url": url,
    };
  }

  factory _17.fromJson(Map<String, dynamic> json) {
    return _17(
      by: json["by"],
      descendants: json["descendants"],
      id: json["id"],
      kids: json["kids"],
      parent: json["parent"],
      score: json["score"],
      time: json["time"],
      title: json["title"],
      type: json["type"],
      url: json["url"],
    );
  }
}

class _9 {
  final String? loremIpsum;

  const _9({
    this.loremIpsum,
  });

  _9 copyWith({
    String? loremIpsum,
  }) {
    return _9(
      loremIpsum: loremIpsum ?? this.loremIpsum,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lorem_ipsum": loremIpsum,
    };
  }

  factory _9.fromJson(Map<String, dynamic> json) {
    return _9(
      loremIpsum: json["lorem_ipsum"],
    );
  }
}

class _6 {
  final List<int>? elements;

  const _6({
    this.elements,
  });

  _6 copyWith({
    List<int>? elements,
  }) {
    return _6(
      elements: elements ?? this.elements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "elements": elements,
    };
  }

  factory _6.fromJson(Map<String, dynamic> json) {
    return _6(
      elements: json["elements"],
    );
  }
}
