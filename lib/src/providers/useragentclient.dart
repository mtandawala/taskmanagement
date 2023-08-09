import 'package:http/http.dart' as http;
import 'dart:io' show Platform;


class UserAgentClient extends http.BaseClient {

  final http.Client _inner;

  UserAgentClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var version = Platform.version;

    request.headers['user-agent'] =  "dart/$version (dart:io) rka_app";
    return _inner.send(request);
  }
}
