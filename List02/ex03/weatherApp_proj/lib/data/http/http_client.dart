import 'package:http/http.dart' as http;

abstract class IHttpRepository {
  Future get({required String url});
}

class HttpRepository implements IHttpRepository{
  final client = http.Client();
  @override
  Future get({required String url}) async {
    return await client.get(Uri.parse(url));
  }
 
}