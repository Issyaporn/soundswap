import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'productPage.dart';
import 'cartPage.dart';
import 'categoryPage.dart';
import 'main.dart';

/*void main() {
  runApp(const HomeScreenApp());
}

class HomeScreenApp extends StatelessWidget {
  const HomeScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreenAppbar(),
    );
  }
}*/

class HomeScreenAppbar extends StatelessWidget {
  const HomeScreenAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<CartItem> cartItems = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('SoundSwap'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
            );
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Go to Search Page',
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
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
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
            ),
            const Carousel(),
            const BestSeller(),
            //_MusicCategories(),
          ],
        ),
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> images = [
    "images/banner/banner1.png",
    "images/banner/banner2.png",
    "images/banner/banner3.png",
    // Add more image paths as needed
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Timer? _timer;
  final Duration _slideDuration =
      const Duration(seconds: 3); // Adjust the duration as needed

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(_slideDuration, (timer) {
      final int nextPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(
            milliseconds: 500), // Adjust the animation duration as needed
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        width: 350,
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  images[index],
                  //fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BestSeller extends StatelessWidget {
  const BestSeller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 16),
              child: const Text(
                "Best Seller",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            _BestSeller(),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 16),
              child: const Text(
                "Music Categories",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            _MusicCategories(),
          ],
        ),
      ),
    );
  }
}

class _BestSeller extends StatelessWidget {
  const _BestSeller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> bestSellers = [
      Product(
        title: 'Melodrama',
        price: 1999.0,
        imageUrl: 'images/cover/pop5.png',
        detail: 'Artist: Lorde',
      ),
      Product(
        title: 'Post',
        price: 3999.0,
        imageUrl: 'images/cover/pop4.png',
        detail: 'Artist: Björk',
      ),
      Product(
        title: 'Abbey Road',
        price: 3999.0,
        imageUrl: 'images/cover/rock1.png',
        detail: 'Artist: The Beatles',
      ),
      Product(
        title: 'Nevermind',
        price: 3999.0,
        imageUrl: 'images/cover/rock4.png',
        detail: 'Artist: Nirvana',
      ),
      Product(
        title: 'The Chronic',
        price: 2999.0,
        imageUrl: 'images/cover/hh2.png',
        detail: 'Artist: Dr Dre',
      ),
    ];

    return SizedBox(
      height: 200, // Adjust the height according to your needs
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: bestSellers.map((product) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: ProductItem(
                    title: product.title,
                    price: product.price,
                    imageUrl: product.imageUrl,
                    detail: product.detail,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  final String title;
  final double price;
  final String imageUrl;
  final String detail;

  const Product({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.detail,
  });
}

class ProductItem extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final String detail;

  const ProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
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
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imageUrl,
              width: 100,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
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

class _MusicCategories extends StatefulWidget {
  @override
  _MusicCategoriesState createState() => _MusicCategoriesState();
}

class _MusicCategoriesState extends State<_MusicCategories> {
  final List<Tab> tabs = [
    Tab(
      text: 'Pop',
    ),
    Tab(
      text: 'Rock',
    ),
    Tab(
      //icon: const Icon(Icons.brightness_5_sharp),
      text: 'HipHop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<MusicType> musicType = [
      MusicType(imageUrl: 'images/pop.png', tab: tabs[0]),
      MusicType(imageUrl: 'images/rock.png', tab: tabs[1]),
      MusicType(imageUrl: 'images/hiphop.png', tab: tabs[2]),
      //MusicType(imageUrl: 'images/product_test.jpg', tab: tabs[3]),
      //MusicType(imageUrl: 'images/product_test.jpg', tab: tabs[4]),
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Align(
            alignment: Alignment.center,
            child: PageView.builder(
              itemCount: musicType.length,
              itemBuilder: (context, index) {
                MusicType product = musicType[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategoryAppBar(
                          initialIndex: tabs.indexOf(product.tab),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: MusicTypeItem(
                      imageUrl: product.imageUrl,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
            Text(
              'Swipe',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MusicType {
  final String imageUrl;
  final Tab tab;

  MusicType({
    required this.imageUrl,
    required this.tab,
  });
}

class MusicTypeItem extends StatelessWidget {
  final String imageUrl;

  const MusicTypeItem({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 10),
      //color: Colors.black,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl,
            width: 250,
            height: 150,
            //fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
