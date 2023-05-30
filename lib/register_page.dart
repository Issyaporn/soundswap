//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _nameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;

  Future<void> _registerUser() async {
    setState(() {
      _nameErrorText = null;
      _emailErrorText = null;
      _passwordErrorText = null;
    });

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _nameErrorText = 'Name is required';
      });
      return;
    }
    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email is required';
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password is required';
      });
      return;
    }

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      var userData = {
        'name': name,
        'email': email,
        'password': password,
        'cart': [],
        'orders': [],
      };

      var jsonData = json.encode(userData);

      try {
        var response = await http.post(
          Uri.parse('http://192.168.59.14:3000/api/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );

        if (response.statusCode == 201) {
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Register Successful'),
              //content: Text('Register Successful'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        });
      } else {
          var errorData = json.decode(response.body);
          var errorMessage = errorData['error'];
          print('Registration failed: $errorMessage');
          // Handle registration failure
        }
      } catch (error) {
        print('Error: $error');
        // Handle error during HTTP request
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Registration',style: TextStyle(color: Colors.black),),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _nameErrorText,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailErrorText,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordErrorText,
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register',style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegistrationPage(),
  ));
}
