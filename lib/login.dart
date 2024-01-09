import 'package:flutter/material.dart';
import 'package:testing/model/api_response.dart';
import 'package:testing/register.dart';
import 'package:testing/screen/home.dart';
import 'package:testing/services/user_services.dart';
import 'package:testing/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});
  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  bool loading = false;

  Future<void> loginUser() async {
    setState(() {
      loading = true;
    });

    ApiResponse response = await login(txtEmail.text, txtPassword.text);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${response.error}'),
        ),
      );
    }
  }

  Future<void> _saveAndRedirectToHome(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.token ?? '');
    await prefs.setInt('userId', user.id ?? 0);
    await prefs.setString('name', user.name ?? '');
    await prefs.setString('email', user.email ?? '');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const UserPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: txtEmail,
                decoration: textBoxStyle("Enter your email", "Email"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email!';
                  }
                  return null;
                },
              ),
              const Divider(),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                decoration: textBoxStyle("Enter your password", "Password"),
                validator: (String? value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a valid password (at least 6 characters)!';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
