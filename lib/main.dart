import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_page.dart';
import 'home_page.dart';
//import 'productPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;

  void _login() {
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty) {
        _emailErrorText = 'Email is required';
      }
      if (password.isEmpty) {
        _passwordErrorText = 'Password is required';
      }

      if (email.isNotEmpty && password.isNotEmpty) {
        // Perform login logic
        // Replace the following lines with your actual login logic

        _performLogin(email, password);
      }
    });
  }

  Future<void> _performLogin(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.59.14:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        var userId = userData['id']; // Get the user ID from the response
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        print(userId);
        setState(() {
          //var responseData = json.decode(response.body);
          //var cartItems = responseData['cartItems'];
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Successful'),
              content: Text('Welcome!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreenAppbar()),
                    );
                    //saveCartItemsToServer(cartItems, email);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          //saveCartItemsToServer(cartItems, email);
        });
      } else {
        var errorData = json.decode(response.body);
        var errorMessage = errorData['error'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(errorMessage),
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
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/UI_BG2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      //width: 20,
                      //height: 150,
                      child: Image.asset(
                        'images/Logo.png',
                        height: 150,
                        //fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to SoundSwap!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'An application for music lovers to buy and sell records.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _emailErrorText,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _passwordErrorText,
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Create an account...'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegistrationPage(),
                                ),
                              );
                            },
                            child: Text('Register',style: TextStyle(color: Colors.white),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
