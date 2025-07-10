import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myHomepage extends StatelessWidget {
  const myHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to your Homepage!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
