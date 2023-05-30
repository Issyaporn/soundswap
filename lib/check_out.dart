import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'package:page_transition/page_transition.dart';

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

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<List<CartItem>> cartItemsFuture;

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
        backgroundColor: Colors.black,
        //flexibleSpace: Image(image: AssetImage('images/bill_bg.jpg'),fit: BoxFit.cover,),
        elevation: 0,
        //title: Text('Checkout'),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: HomeScreenAppbar(),
                type: PageTransitionType.bottomToTop,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bill_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<List<CartItem>>(
            future: cartItemsFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final cartItems = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 150,
                      child: Image.asset(
                        'images/Logo_bill.png',
                        //fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORDER #0000 FOR MUSIC LOVER',
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'SEPTEMBER 9, 2023 07:35 PM',
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '--------------------------------------------------------',
                      style: TextStyle(fontSize: 24),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Center(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(cartItem.title),
                                    SizedBox(
                                      width: 100,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${cartItem.price.toStringAsFixed(2)} BAHT',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      '--------------------------------------------------------',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${getTotalPrice(cartItems).toStringAsFixed(2)} BAHT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                    Text(
                      '--------------------------------------------------------',
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      width: 200,
                      child: Image.asset(
                        'images/barcode.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'THANK YOU FOR YOUR ORDER',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  double getTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;
    for (var cartItem in cartItems) {
      totalPrice += cartItem.price;
    }
    return totalPrice;
  }
}
