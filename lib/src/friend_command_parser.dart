class FriendCommandParser {
  static final _addFriendPattern = RegExp(
    r'''^\s*add_friend\s+"((?:\\.|[^"])*)"\s+"((?:\\.|[^"])*)"\s*$''',
    caseSensitive: false,
  );

  static final _addPlayerPattern = RegExp(
    r'''^\s*add_player\s+(?:"((?:\\.|[^"])*)"|'((?:\\.|[^'])*)'|([^\s"'].*?))\s*$''',
    caseSensitive: false,
  );

  static List<String> parse(String input) {
    final names = <String>[];
    final invalidLines = <int>[];
    final seen = <String>{};
    final lines = input.split(RegExp(r'[\r\n]+'));

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();
      if (line.isEmpty || line.startsWith('#') || line.startsWith('//')) {
        continue;
      }
      final addFriendMatch = _addFriendPattern.firstMatch(line);
      final addPlayerMatch = _addPlayerPattern.firstMatch(line);
      final rawName = addFriendMatch?.group(1) ??
          addPlayerMatch?.group(1) ??
          addPlayerMatch?.group(2) ??
          addPlayerMatch?.group(3);
      final name = rawName?.trim();
      if (name == null || name.isEmpty) {
        invalidLines.add(index + 1);
        continue;
      }
      final decodedName = _unescape(name);
      if (decodedName.isEmpty) {
        invalidLines.add(index + 1);
        continue;
      }
      if (seen.add(decodedName.toLowerCase())) {
        names.add(decodedName);
      }
    }

    if (invalidLines.isNotEmpty) {
      throw FormatException(
        'No reconocí los comandos add_friend o add_player en la(s) línea(s) '
        '${invalidLines.join(', ')}.',
      );
    }
    if (names.isEmpty) {
      throw const FormatException(
        'Pegá al menos un comando add_friend o add_player.',
      );
    }
    return names;
  }

  static String _unescape(String value) {
    return value.replaceAllMapped(
      RegExp(r'''\\(["'\\])'''),
      (match) => match.group(1)!,
    );
  }
}
