import 'package:flutter/material.dart';
import 'package:generic_company_application/screens/utils/helpers.dart';
import 'package:generic_company_application/screens/widgets/text_fields_widget.dart';
import 'package:generic_company_application/screens/post_screens/posts_view_screen.dart';
import 'package:generic_company_application/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController companyController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Static OTP
  final String staticOtp = "123456";

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();

      final error = await authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (error == null) {
          
        Helpers.showSuccessSnackbar(context, "Signup Successful 🎉");
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Company Name
              TextFieldsWidget(
                controller: companyController,
                prefixIcon: Icons.home,
                labelText: "Company Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Company name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              /// User Name
              TextFieldsWidget(
                controller: userController,
                labelText: "User Name",
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "User name is required";
                  }
                  if (value.length < 3) {
                    return "User name must be at least 3 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFieldsWidget(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter a valid email address";
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
                prefixIcon: Icons.password,
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
              const SizedBox(height: 15),

              /// Confirm Password
              TextFieldsWidget(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                labelText: "Confirm Password",
                prefixIcon: Icons.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm your password";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Phone Number
              TextFieldsWidget(
                controller: phoneController,
                keyboardType: TextInputType.phone,

                labelText: "Phone Number",
                prefixIcon: Icons.phone,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              /// Static OTP Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Your OTP: $staticOtp",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              /// OTP Field
              TextFieldsWidget(
                controller: otpController,
                keyboardType: TextInputType.number,

                labelText: "Enter OTP",
                prefixIcon: Icons.lock_reset,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "OTP is required";
                  }
                  if (value != staticOtp) {
                    return "Invalid OTP";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              /// Submit Button
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => LoginScreen()),
              //     );
              //   },
              //   child: const Text("Already have an account? Log in"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
