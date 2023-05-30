import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'productPage.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'cartPage.dart';

List<String> titles = <String>[
  'Pop',
  'Rock',
  'HipHop',
];

class CategoryAppBar extends StatelessWidget {
  final int initialIndex;

  const CategoryAppBar({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;
    //List<CartItem> cartItems = [];

    return DefaultTabController(
      initialIndex: initialIndex,
      length: tabsCount,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
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
          title: const Text('Music Categories'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: titles[0]),
              Tab(text: titles[1]),
              Tab(text: titles[2]),
              //Tab(text: titles[3]),
              //Tab(text: titles[4]),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _MusicTypeProduct(selectedCategory: 'Pop'),
            _MusicTypeProduct(selectedCategory: 'Rock'),
            _MusicTypeProduct(selectedCategory: 'Hiphop'),
            //_MusicTypeProduct(selectedCategory: 'Music4'),
            //_MusicTypeProduct(selectedCategory: 'Music5'),
          ],
        ),
      ),
    );
  }
}

class _MusicTypeProduct extends StatefulWidget {
  final String selectedCategory;
  

  const _MusicTypeProduct({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  _MusicTypeProductState createState() => _MusicTypeProductState();
}

class _MusicTypeProductState extends State<_MusicTypeProduct>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Product> products = [];

  List<Product> parseProducts(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    final List<Product> products = parsedJson.map((json) {
      return Product(
        title: json['title'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        category: json['category'],
        detail: json['detail'],
      );
    }).toList();

    return products;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    loadProducts();
  }

  Future<void> loadProducts() async {
    final jsonProducts =
        await rootBundle.loadString('jsonFile/productsData.json');
    final parsedProducts = parseProducts(jsonProducts);
    setState(() {
      products = parsedProducts;
    });
  }

  List<Product> getFilteredProducts() {
    return products
        .where((product) => product.category == widget.selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

    return DefaultTabController(
      length: 1,
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 130,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: const EdgeInsets.all(10),
                      childAspectRatio: 1 / 1.5,
                      children: filteredProducts.map((product) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          child: ProductItem(
                            title: product.title,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            category: product.category,
                            detail: product.detail,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final String detail;

  const Product({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.detail,
  });
}

class ProductItem extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final String detail;

  const ProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: ProductPage(
              title: title,
              price: price,
              imageUrl: imageUrl,
              detail: detail,
            ),
            type: PageTransitionType.bottomToTop,
            duration: Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 120,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Image.asset(
                imageUrl,
                width: 150,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${price.toStringAsFixed(2)}\ Baht',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
