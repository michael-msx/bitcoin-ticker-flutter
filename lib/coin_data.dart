import 'dart:convert';
import 'package:http/http.dart' as http;

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '<your api key>';

class CoinData {
  Future getCoinData(target, currency) async {
    String requestURL = '$coinAPIURL/$target/$currency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(requestURL));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var lastPrice = decodedData['rate'];
      return lastPrice;
    } else {
      print(response.statusCode);
    }
  }
}
