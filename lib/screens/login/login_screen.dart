import 'package:flutter/material.dart';
import 'package:generic_company_application/screens/common_widgets/text_fields_widget.dart';
import 'package:generic_company_application/screens/post_screens/posts_view_screen.dart';
import 'package:generic_company_application/screens/utils/helpers.dart';
import 'package:generic_company_application/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();

      final error = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (error == null) {
        Helpers.showSuccessSnackbar(context, "Login Successful ✅");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PostsViewScreen()),
        );

        _formKey.currentState!.reset();
      } else {
        Helpers.showErrorSnackbar(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Email
              TextFieldsWidget(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,

                prefixIcon: Icons.email,
                labelText: "Email",

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              /// Password
              TextFieldsWidget(
                controller: passwordController,
                obscureText: !isPasswordVisible,

                labelText: "Password",
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Login Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => SignupScreen()),
              //     );
              //   },
              //   child: const Text("Don't have an account? Sign Up"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
