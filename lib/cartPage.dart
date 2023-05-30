import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'check_out.dart';
//import 'dart:io';

class CartItem {
  final String title;
  final double price;
  final String imageUrl;

  CartItem({
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> cartItemsFuture;
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItemsFuture = fetchCartItems();
  }

  Future<List<CartItem>> fetchCartItems() async {
    final response =
        await http.get(Uri.parse('http://192.168.59.14:3000/api/users'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<CartItem> cartItems = [];

      for (final userData in responseData) {
        final List<dynamic> cartData = userData['cart'];
        cartData.forEach((item) {
          final cartItem = CartItem(
            title: item['title'],
            price: item['price'].toDouble(),
            imageUrl: item['imageUrl'],
          );
          cartItems.add(cartItem);
        });
      }

      return cartItems;
    } else {
      throw Exception('Failed to fetch cart items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<CartItem>>(
        future: cartItemsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cartItems = snapshot.data!;
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            cartItem.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${cartItem.price.toStringAsFixed(2)} Baht',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: CheckoutPage(),
              type: PageTransitionType.topToBottom,
              duration: Duration(milliseconds: 1500),
            ),
          );
        },
        label: const Text(
          'Check Out',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
