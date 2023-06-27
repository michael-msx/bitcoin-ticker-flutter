import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'const.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var label = {};

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> currencyList = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        value: currency,
        child: Text(currency),
      );
      currencyList.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker getIosPicker() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedCurrency) {
        print(selectedCurrency);
      },
      children: items,
    );
  }

  @override
  void initState() {
    super.initState();
    for (String crypto in cryptoList) {
      label[crypto] = '?';
    }
    getData();
  }

  Widget getPicker() {
    if (kIsWeb) {
      return androidPicker();
    }

    if (Platform.isIOS) {
      return getIosPicker();
    } else {
      return androidPicker();
    }
  }

  //11. Create an async method here await the coin data from coin_data.dart
  void getData() async {
    try {
      for (String crypto in cryptoList) {
        double data = await CoinData().getCoinData(crypto, selectedCurrency);
        setState(() {
          label[crypto] = data.toStringAsFixed(2);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<Card> getSupportCrypto() {
    List<Card> cryptos = [];
    for (String crypto in cryptoList) {
      String rate = label[crypto];

      var item = Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
      cryptos.add(item);
    }
    return cryptos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: getSupportCrypto(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
