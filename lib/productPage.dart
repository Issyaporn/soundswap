import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cartPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final String title;
  final double price;
  final String imageUrl;
  final String detail;

  const ProductPage({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.detail,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: CartScreen(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                '${widget.price} Bath',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 24),
              child: ElevatedButton(
                //style: ButtonStyle(backgroundColor: Colors.white),
                onPressed: () {
                  // Save cart items to the server
                  saveCartItemsToServer(
                      cartItems, widget.title, widget.price, widget.imageUrl);
                },

                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context)
              .size
              .height, // Adjust the height constraint as needed
          child: ProductDetail(
            imageUrl: widget.imageUrl,
            title: widget.title,
            detail: widget.detail,
          ),
        ),
      ),
    );
  }

  Future<void> saveCartItemsToServer(List<CartItem> cartItems, String title,
      double price, String imageUrl) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      print(userId);

      if (userId != null) {
        // Create the product data
        final product = {
          'title': title,
          'price': price,
          'imageUrl': imageUrl,
          // Add other relevant fields if needed
        };

        // Send a POST request to add the product to the user's cart
        final cartResponse = await http.post(
          Uri.parse('http://192.168.59.14:3000/api/users/cart'),
          headers: {'Content-Type': 'Application/json'},
          body: jsonEncode({
            'userId': userId,
            'product': product,
          }),
        );

        if (cartResponse.statusCode == 200) {
          // Update the status code check to 201
          setState(() {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Product added to cart.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          });
          print('Product added to cart.');
          print('Product added to cart: $product');
        } else {
          print(
              'Failed to add product to cart. Status code: ${cartResponse.statusCode}');
        }
      } else {
        print('User ID not found.');
        // Handle the case when the user ID is not found
      }
    } catch (error) {
      print('Error adding product to cart: $error');
    }
  }
}

class ProductDetail extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String detail;

  ProductDetail({
    required this.imageUrl,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                  //left: 5,
                  child: Container(
                width: 250,
                height: 250,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                detail,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
