import 'package:flutter/material.dart';
import 'package:shop/views/cart_screen.dart';
import './views/products_overview_screen.dart';
import './views/product_detail_screen.dart';

import './utils/app_routes.dart';

import 'package:provider/provider.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
