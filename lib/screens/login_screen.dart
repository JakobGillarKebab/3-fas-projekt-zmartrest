import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zmartrest/main_scaffold.dart';
import 'package:zmartrest/pocketbase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  void _validateFields() {
    setState(() {
      _emailError = _emailController.text.trim().isEmpty
          ? 'Email is required'
          : null;

      _passwordError = _passwordController.text.trim().isEmpty
          ? 'Password is required'
          : null;
    });
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Input Error', style: TextStyle(color: Color(0xFFFFFFFF))),
          description: Text('Please enter both email and password', style: TextStyle(color: Color(0xFFFFFFFF))),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await authenticateUser(email, password);

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScaffold(),
        ),
      );
    } else {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Login Failed', style: TextStyle(color: Color(0xFFFFFFFF))),
          description: Text('Invalid credentials, please try again.', style: TextStyle(color: Color(0xFFFFFFFF))),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadToaster(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailInput(controller: _emailController),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              PasswordInput(controller: _passwordController),
              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ShadButton(
                onPressed: _handleLogin,
                child: const Text('Login')
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EmailInput extends StatefulWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: widget.controller,
      placeholder: const Text('Email'),
      obscureText: false,
      prefix: const Padding(
        padding: EdgeInsets.all(4.0),
        child: ShadImage.square(size: 16, LucideIcons.mail),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: widget.controller,
      placeholder: const Text('Password'),
      obscureText: obscure,
      prefix: const Padding(
        padding: EdgeInsets.all(4.0),
        child: ShadImage.square(size: 16, LucideIcons.lock),
      ),
      suffix: ShadButton(
        width: 24,
        height: 24,
        padding: EdgeInsets.zero,
        decoration: const ShadDecoration(
          secondaryBorder: ShadBorder.none,
          secondaryFocusedBorder: ShadBorder.none,
        ),
        icon: ShadImage.square(
          size: 16,
          obscure ? LucideIcons.eyeOff : LucideIcons.eye,
        ),
        onPressed: () {
          setState(() => obscure = !obscure);
        },
      ),
    );
  }
}
