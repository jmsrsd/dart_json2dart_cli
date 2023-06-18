import 'package:dart_json2dart_cli/src/core.dart';

Future<void> execute(List<String> arguments) async {
  for (final argument in arguments) {
    print(argument);
  }

  final json = {
    "by": "dhouston",
    "descendants": 71,
    "id": 8863,
    "kids": {
      "elements": [
        8952,
        9224,
        8917,
        8884,
        8887,
        8943,
        8869,
        8958,
        9005,
        9671,
        8940,
        9067,
        8908,
        9055,
        8865,
        8881,
        8872,
        8873,
        8955,
        10403,
        8903,
        8928,
        9125,
        8998,
        8901,
        8902,
        8907,
        8894,
        8878,
        8870,
        8980,
        8934,
        8876
      ],
    },
    "parent": [
      {
        "lorem_ipsum": "foo_bar",
      },
    ],
    "score": 111,
    "time": 1175714200,
    "title": "My YC app: Dropbox - Throw away your USB drive",
    "type": "story",
    "url": "http://www.getdropbox.com/u/2/screencast.html"
  };

  // print(jsonEncode(json));
  // print('');
  // print('---');
  // print('');

  final token = tokenize(json);

  convert(token);

  print(classes.entries.toList().reversed.map((e) {
    var lines = e.value.split('\n');

    final constructor = createConstructor(e.key, e.value);

    lines = [
      ...lines.sublist(0, lines.length - 1),
      '',
      ...constructor.split('\n').map((e) {
        return '  $e';
      }),
      '}',
    ];

    final copyWith = createCopyWith(e.key, e.value);

    lines = [
      ...lines.sublist(0, lines.length - 1),
      '',
      ...copyWith.split('\n').map((e) {
        return '  $e';
      }),
      '}',
    ];

    final toJson = createToJsonFactory(e.key, e.value);

    lines = [
      ...lines.sublist(0, lines.length - 1),
      '',
      ...toJson.split('\n').map((e) {
        return '  $e';
      }),
      '}',
    ];

    final fromJson = createFromJsonFactory(e.key, e.value);

    return [
      ...lines.sublist(0, lines.length - 1),
      '',
      ...fromJson.split('\n').map((e) {
        return '  $e';
      }),
      '}',
    ].join('\n');
  }).join('\n\n'));
}
