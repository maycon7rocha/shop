import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/tabs_screen.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context, listen: false).loadOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
          future: orderData,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return Center(child: Text('Ocorreu um erro!'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, child) {
                  return ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
                  );
                },
              );
            }
          },
        ),
      ),
      // _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         itemCount: orders.itemsCount,
      //         itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      //       ),
      bottomNavigationBar: TabsScreen(),
    );
  }
}
