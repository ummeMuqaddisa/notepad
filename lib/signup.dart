import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // ✅ Controllers for the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

     /* appBar: AppBar(
        backgroundColor: Colors.white24, // ✅ Add a visible background
        foregroundColor: Colors.black, // ✅ Makes icons match titleTextStyle
        toolbarHeight: 80, // optional, adjust height if you want
        title: const Text("Sign up"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          height: 1.2,
        ),

      ),*/


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch, // Button full width

          children: [
            SizedBox(height: 160),


            /*TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),*/

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(), // This is the default border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // Light border when not focused
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8F5E8B), // Border color when focused
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // This is the default border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // Light border when not focused
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8F5E8B), // Border color when focused
                    width: 2.0,
                  ),
                ),
              ),
            ),



           /* TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),*/
            const SizedBox(height: 24),

            /*ElevatedButton(
              style: ButtonStyle(backgroundColor: Colors.),
              onPressed: () {
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
              },
              child: const Text("Sign up"),
            ),*/

            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // light grey
                foregroundColor: Colors.black87,   // soft black text
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0, // makes it flatter, more minimal
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
              child: const Text("Sign up"),
            )*/

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
                    password: _passwordController.text,
                  );
                } catch (e) {
                  // Handle error
                }
              },
              child: const Text(
                "Sign up",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )




          ],
        ),
      ),
    );
  }
}
