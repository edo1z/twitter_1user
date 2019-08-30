import 'dart:io' show Platform;
import 'dart:convert';
import 'package:twitter_1user/twitter_1user.dart';

Future<void> main(List<String> arguments) async {
  Map<String, String> env = Platform.environment;
  Twitter twitter = new Twitter(env['API_KEY'], env['API_SECRET'],
      env['ACCESS_TOKEN'], env['ACCESS_SECRET']);

  String response = await twitter
      .request('GET', 'statuses/user_timeline.json', {'trim_user': 'true'});
  var tweets = jsonDecode(response);
  print(tweets[1]['text']);

  response = await twitter
      .request('post', "statuses/update.json", {'status': 'Hello, ワールド!'});
  print(response);
}
