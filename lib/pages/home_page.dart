import 'dart:convert';

import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;

  _HomePageState();

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = ["bitcoin"];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _coins.first,
      items: _items,
      onChanged: (_value) {},
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
        future: _http!.get("/coins/bitcoin"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            Map _data = jsonDecode(
              _snapshot.data..toString(),
            );
            // num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _inrPrice = _data["market_data"]["current_price"]["inr"];
            return Text(_inrPrice.toString());
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }
}
