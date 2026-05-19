import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/core/constants/app_images.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/features/auth/presentation/components/auth_textfield.dart';
import 'package:leaf_notes/features/auth/utils/auth_validator.dart';
import 'package:leaf_notes/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!_formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthValidationFailed());
      return;
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    context.read<AuthBloc>().add(LoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF4EEDF),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA8B58A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -90,
            child: Container(
              height: 270,
              width: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA8B58A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(AppImages.bottomLeaves, fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Image.asset(AppImages.appIcon, height: 150),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.052,
                    ),
                    // Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Login",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 40,
                              height: 2,
                              color: Colors.green,
                            ),
                          ],
                        ),

                        const SizedBox(width: 30),

                        GestureDetector(
                          onTap: () {
                            widget.togglePages?.call();
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    AuthTextfield(
                      hintText: "Email",
                      textfieldIcon: const Icon(Icons.email_outlined),
                      controller: emailController,
                      obscureText: false,
                      validator: (value) =>
                          AuthValidator.validateEmail(value ?? ""),
                    ),

                    const SizedBox(height: 16),

                    AuthTextfield(
                      hintText: "Password",
                      textfieldIcon: const Icon(Icons.lock_outline),
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) =>
                          AuthValidator.validatePassword(value ?? ""),
                    ),

                    const SizedBox(height: 30),

                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        }

                        if (state is AuthError) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: Container(
                          height: 45,
                          width: 186,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account?  ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.togglePages?.call();
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
