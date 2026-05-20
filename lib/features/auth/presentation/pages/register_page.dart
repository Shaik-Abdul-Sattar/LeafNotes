import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/core/constants/app_images.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/features/auth/presentation/components/auth_textfield.dart';
import 'package:leaf_notes/features/auth/utils/auth_validator.dart';
import 'package:leaf_notes/presentation/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void register() {
    if (!_formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthValidationFailed());
      return;
    }

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    context.read<AuthBloc>().add(RegisterRequested(email, password, username));
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
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                    // Image.asset(AppImages.appIcon, height: 150),
                    // const SizedBox(height: 20),
                    // Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.togglePages?.call();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 30),

                        Column(
                          children: [
                            const Text(
                              "Register",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 40,
                              height: 2,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    AuthTextfield(
                      hintText: "Username",
                      textfieldIcon: const Icon(Icons.person_outline),
                      controller: usernameController,
                      obscureText: false,
                      validator: (value) =>
                          AuthValidator.validateUsername(value ?? ""),
                    ),

                    const SizedBox(height: 16),

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
                      obscureText: obscureText,
                      validator: (value) =>
                          AuthValidator.validatePassword(value ?? ""),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
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
                          register();
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
                              "REGISTER",
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
                          "Already have an Account?  ",
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.togglePages?.call();
                          },
                          child: const Text(
                            "Log In",
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
