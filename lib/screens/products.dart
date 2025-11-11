import 'package:app_final/screens/Side_Menu.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget{
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: SideMenu(scaffoldKey:scaffoldKey),
      appBar: AppBar(
        title: const Text ('products'),
        actions: [
          IconButton(onPressed: (){}, 
          icon: const Icon(Icons.search_off_sharp)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
      );
  }
}
class _ProductsView extends StatelessWidget{
  const _ProductsView();
  @override
  Widget build(BuildContext context) {
   return const Center(child: Text('Eres genial!'));

  }
}
 