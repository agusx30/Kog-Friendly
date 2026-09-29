import 'package:flutter_test/flutter_test.dart';
import 'package:kog_friends/src/friend_command_parser.dart';

void main() {
  group('FriendCommandParser', () {
    test('reads names from add_friend and ignores the clan field', () {
      final names = FriendCommandParser.parse(
        r'''add_friend "Dkz'" "|*KoG*|"
add_friend "Floῳless" ""
add_friend "Serafim" ""
add_friend "Peoxx" ""
add_friend "Zer0" ""
add_friend "agusx30" ""''',
      );

      expect(
        names,
        ["Dkz'", 'Floῳless', 'Serafim', 'Peoxx', 'Zer0', 'agusx30'],
      );
    });

    test('continues to parse add_player and escaped names', () {
      final names = FriendCommandParser.parse(
        r'''add_player PlayerOne
add_player "Tee \"Ace\""''',
      );

      expect(names, ['PlayerOne', 'Tee "Ace"']);
    });

    test('reports malformed command lines', () {
      expect(
        () => FriendCommandParser.parse(
          'add_player "Good"\nremove_player "Bad"\n'
          'add_friend "Name" "Clan" extra',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects empty input', () {
      expect(
        () => FriendCommandParser.parse('  \n# config comment'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
