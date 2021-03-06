import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shop/utils/constants.dart';
import './product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/cart';
  Map<String, CartItem> _items = {};

  String _token;
  String _userId;

  Cart([this._token, this._userId, this._items = const {}]);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> loadCart() async {
    // List<CartItem> loadedItems = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> _items = json.decode(response.body);
    // print(data);
    // print(data.length);

    // if (data != null) {
      // data.forEach((cartId, cardData) {
        // _items.addAll(data);
        // loadedItems.add(
        //   CartItem(
        //   id: cardData.id,
        //   productId: cartId,
        //   title: cardData.title,
        //   quantity: cardData.quantity + 1,
        //   price: cardData.price,
        // )
        // );
        // _items.addAll(cardData);
      // });
      // print('tem dados'); 
    // }
    // _items.addAll(data);


    // print('fora');
    // print(loadedItems);
    print(_items);

    notifyListeners();
    // _items = loadedItems;
    return Future.value();
  }

  Future<void> addItem(Product product) async {
    final url = "$_baseUrl/$_userId.json?auth=$_token";

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: product.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );

      final cartResponse = await http.get(url);
      final data = json.decode(cartResponse.body);
      if (data != null) {
        data.forEach((cartId, cartData) {
          if (cartData['productId'] == product.id) {
            http.patch(
              "$_baseUrl/$_userId/$cartId.json?auth=$_token",
              body: json.encode({
                'quantity': cartData['quantity'] + 1,
              }),
            );
          }
        });
      }
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );

      await http.post(
        url,
        body: json.encode({
          'id': Random().nextDouble().toString(),
          'productId': product.id,
          'title': product.title,
          'quantity': 1,
          'price': product.price,
        }),
      );
    }

    notifyListeners();

    // print(response.body);
    return Future.value();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
