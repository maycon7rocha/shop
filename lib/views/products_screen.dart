import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_FORM,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.itemsCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              ProductItem(products[i]),
              Divider(),
            ],
          ),
          
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
