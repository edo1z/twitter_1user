twitter 1user
===

[![pub package](https://img.shields.io/pub/v/twitter_1user.svg)](https://pub.dev/packages/twitter_1user)

Connect to Twitter API with OAuth1.0a. The access token is assumed to be obtained from the Twitter application details page. It is therefore ideal for single user applications.

## Install

Add this to your package's pubspec.yaml file.

```yaml
dependencies:
  twitter_1user: ^1.0.0
```

You can install packages from the command line.

```shell
pub get
```


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
