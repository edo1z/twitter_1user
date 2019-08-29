twitter 1user
===

Twitter OAuth library for single user. For Dart.

## Example

```dart
import 'package:twitter_1user/twitter_1user.dart';

main(List<String> arguments) async {
  Twitter twitter = new Twitter('CONSUMER KEY', 'CONSUMER SECRET',
      'ACCESS TOKEN', 'ACCESS TOKEN SECRET');

  String response = await twitter.request(
      'get', 'statuses/user_timeline.json', {});
  var tweets = jsonDecode(response);
  print(tweets[2]);

  response =
  await twitter.request('post', 'statuses/update.json', {'status': 'Hello!'});
  print(response);
}
```

## LICENSE

MIT
