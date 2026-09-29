import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kog_friends/src/kog_presence_service.dart';

void main() {
  group('KogPresenceService', () {
    test('matches friends case-insensitively and returns server details',
        () async {
      final client = MockClient((request) async {
        return http.Response(
          '''
          {
            "servers": [
              {
                "community": "kog",
                "location": "eu:de",
                "info": {
                  "name": "KOG Solo",
                  "map": {"name": "TestMap"},
                  "clients": [{"name": "Player One", "is_player": true}]
                }
              },
              {
                "community": "ddnet",
                "info": {
                  "name": "DDNet Server",
                  "map": {"name": "Other"},
                  "clients": [{"name": "Player Two", "is_player": true}]
                }
              }
            ]
          }
          ''',
          200,
        );
      });
      final service = KogPresenceService(client);

      final result = await service.findFriends(['PLAYER ONE', 'Player Two']);

      expect(result.keys, ['player one']);
      expect(result['player one']?.serverName, 'KOG Solo');
      expect(result['player one']?.mapName, 'TestMap');
      service.close();
    });

    test('uses the ETag cache after a not-modified response', () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        if (requestCount == 1) {
          return http.Response(
            '{"servers":[{"community":"kog","info":{"name":"KOG","map":{"name":"Map"},"clients":[{"name":"Friend"}]}}]}',
            200,
            headers: {'etag': '"test-etag"'},
          );
        }
        expect(request.headers['if-none-match'], '"test-etag"');
        return http.Response('', 304);
      });
      final service = KogPresenceService(client);

      final first = await service.findFriends(['Friend']);
      final second = await service.findFriends(['Friend']);

      expect(first.keys, ['friend']);
      expect(second.keys, ['friend']);
      expect(requestCount, 2);
      service.close();
    });

    test('throws an explicit error for unsuccessful server responses',
        () async {
      final service = KogPresenceService(
        MockClient((request) async => http.Response('unavailable', 503)),
      );

      await expectLater(
        service.findFriends(['Friend']),
        throwsA(isA<http.ClientException>()),
      );
      service.close();
    });
  });
}
