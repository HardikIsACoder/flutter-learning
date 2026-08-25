import 'package:flutter/material.dart';
import 'package:shoe_app/providers/cart_provider.dart';
import 'package:shoe_app/widgets/confirmation_dialog.dart';
import 'package:shoe_app/global_variables.dart';
import 'package:shoe_app/pages/product_details_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final cartItem = cart[index];
          if (cart.isNotEmpty) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetailsPage(
                          product: products[int.parse(cartItem['id'])]);
                    },
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage(cartItem['imageUrl'] as String),
                radius: 30,
              ),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return ConfirmationDialog(
                          onConfirm: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeProduct(cartItem);
                          },
                        );
                      });
                },
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.red,
              ),
              title: Text(
                cartItem['title'].toString(),
                // style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text('Size: ${cartItem['size']}'),
            );
          } else {
            return const Text("Cart is Empty");
          }
        },
      ),
    );
  }
}
