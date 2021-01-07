import 'package:flutter/material.dart';
// import 'package:shop/views/orders_screen.dart';
// import 'package:shop/views/products_overview_screen.dart';
// import 'package:shop/views/products_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;

  // List<Map<String, Object>> _screens;

/*   @override
  void initState() {
    super.initState();
    _screens = [
      {
        'title': 'Produtos',
        'screen': ProductOverviewScreen(),
      },
      {
        'title': 'Meus Pedidos',
        'screen': OrdersScreen(),
      },
      {
        'title': 'Gerenciar Produtos',
        'screen': ProductsScreen(),
      },
    ];
  } */

  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: _selectedScreenIndex,
      onTap: _selectScreen,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'Loja',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Meus Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Gerenciar Produtos',
        ),
      ],
    );
  }
}
