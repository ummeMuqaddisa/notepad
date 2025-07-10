import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'importantNotes.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // ✅ Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign up")  ,
        titleTextStyle: const TextStyle(
          color: Color(0xFF714A6D),
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2
        ),

    ),



      body:
      Stack(
    children: [

    Positioned(
    top: -100,
      left: -100,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFFEFD3F5).withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    ),


    Positioned(
    bottom: -120,
    right: -80,
    child: Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
    color: const Color(0xFFD7C4E2).withOpacity(0.4),
    shape: BoxShape.circle,
    ),
    ),
    ),


    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const SizedBox(height: 160),


    TextField(
    controller: _emailController,
    decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.grey,
    width: 1.5,
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Color(0xFF8F5E8B),
    width: 2.0,
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),


    TextField(
    controller: _passwordController,
    obscureText: _obscureText,
    decoration: InputDecoration(
    labelText: 'Password',
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.grey,
    width: 1.5,
    ),
    ),
    focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(
    color: Color(0xFF8F5E8B),
    width: 2.0,
    ),
    ),
    suffixIcon: IconButton(
    icon: Icon(
    _obscureText ? Icons.visibility_off : Icons.visibility,
    ),
    onPressed: () {
    setState(() {
    _obscureText = !_obscureText;
    });
    },
    ),
    ),
    ),

    const SizedBox(height: 24),

    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF8F5E8B),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),


    onPressed: () async {
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    );
    } catch (e) {
    print('Error: $e');
    }
    },
    child: const Text(
    "Sign up",
    style: TextStyle(fontWeight: FontWeight.w600),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    );
  }
}
