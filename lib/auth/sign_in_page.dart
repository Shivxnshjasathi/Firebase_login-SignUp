import 'package:assigment/auth/sign_up_page.dart';
import 'package:assigment/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign in successful!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = e.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 31, 127, 139),
              fontSize: 25.0,
              fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {}),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                Text("Sign In your account",
                    style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 40.0),
                Container(
                  height: 60,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color.fromARGB(255, 31, 127, 139),
                          ),
                          border: InputBorder.none,
                          labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 60,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.black54,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: Color.fromARGB(255, 31, 127, 139),
                          ),
                          border: InputBorder.none,
                          labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            side: const BorderSide(
                                color: Colors.black54, width: 1.5),
                            value: false,
                            onChanged: (value) {}),
                        const Text("Remember me"),
                      ],
                    ),
                    const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 31, 127, 139),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : InkWell(
                        onTap: _signIn,
                        child: Container(
                            height: 60,
                            width: 400,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 2, 20, 35),
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            )),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            "Don't have an account  ? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Sign up here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 31, 127, 139),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
