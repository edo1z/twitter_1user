import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class Twitter {
  static const String _baseUrl = 'https://api.twitter.com/1.1/';
  final Map<String, String> authData = {};
  final String api_secret, access_secret;

  Twitter(api_key, this.api_secret, access_token, this.access_secret) {
    authData['oauth_consumer_key'] = api_key;
    authData['oauth_token'] = access_token;
    authData['oauth_signature_method'] = 'HMAC-SHA1';
    authData['oauth_version'] = '1.0';
  }

  Future<String> request(String method, String path,
      Map<String, String> requestData) async {
    final String url = _baseUrl + path;
    method = method.toUpperCase();
    authData['oauth_timestamp'] = _timestamp();
    authData['oauth_nonce'] = _nonce();
    authData['oauth_signature'] = _signature(method, url, requestData);
    String authHeader = _headerString();
    return await _request(method, url, authHeader, requestData);
  }

  Future<String> _request(String method, String url, String authHeader,
      Map<String, String> data) async {
    final List<String> list =
    data.keys.map((key) => "$key=${_per(data[key])}").toList();
    String queryString = list.join('&');
    if (method == 'GET') url += '?' + queryString;
    final HttpClient http = new HttpClient();
    final HttpClientRequest request =
    await http.openUrl(method, Uri.parse(url));
    request.headers
      ..contentType = new ContentType('application', 'x-www-form-urlencoded',
          charset: "utf-8")
      ..add("Authorization", authHeader);
    if (method == 'POST') request.write(queryString);
    final HttpClientResponse response = await request.close().whenComplete(
        http.close);
    return response.transform(utf8.decoder).join("");
  }

  String _nonce() {
    math.Random rnd = new math.Random();
    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
    return base64Encode(values).replaceAll(new RegExp('[=/+]'), '');
  }

  String _signature(String method, String url,
      Map<String, String> requestData) {
    Map<String, String> data = {...authData, ...requestData};
    List<String> list = data.keys
        .map((key) => "${_per(key)}=${_per(data[key])}")
        .toList()
      ..sort();
    String parameters = _per(list.join('&'));
    String signatureBaseString = "$method&${_per(url)}&$parameters";
    String signatureKey = "${_per(api_secret)}&${_per(access_secret)}";
    Hmac hmacSha1 = new Hmac(sha1, utf8.encode(signatureKey));
    List<int> signature =
        hmacSha1
            .convert(utf8.encode(signatureBaseString))
            .bytes;
    return base64.encode(signature);
  }

  String _per(String str) => percent.encode(utf8.encode(str));

  String _timestamp() {
    double sec = new DateTime.now().millisecondsSinceEpoch / 1000;
    return sec.floor().toString();
  }

  String _headerString() {
    List<String> list = authData.keys
        .map((key) => "${_per(key)}=\"${_per(authData[key])}\"")
        .toList();
    return 'OAuth ' + list.join(', ');
  }
}
