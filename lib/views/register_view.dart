import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool  _hidePassword   = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passwordCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final ok = await context.read<AuthViewModel>().register(
      _nameCtrl.text, _emailCtrl.text,
      _passwordCtrl.text, _confirmCtrl.text,
    );
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please Login.'),
          // "Account created successfully! Please login."
          backgroundColor: Color(0xFF00695C),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create new Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Join SL Fashion',
                // "Join SL Fashion"
                style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00695C),
                )),
              const SizedBox(height: 6),
              const Text('Fill in your details to create your account.',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 28),

              _label('Full Name'),
              const SizedBox(height: 6),
              TextField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => context.read<AuthViewModel>().clearError(),
                decoration: const InputDecoration(
                  hintText: 'e.g. Kumari Perera',
                  prefixIcon: Icon(Icons.person_outlined, color: Color(0xFF00695C)),
                ),
              ),
              const SizedBox(height: 16),

              _label('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => context.read<AuthViewModel>().clearError(),
                decoration: const InputDecoration(
                  hintText: 'example@gmail.com',
                  prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF00695C)),
                ),
              ),
              const SizedBox(height: 16),

              _label('Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordCtrl,
                obscureText: _hidePassword,
                onChanged: (_) => context.read<AuthViewModel>().clearError(),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00695C)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _label('Confirm Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmCtrl,
                obscureText: true,
                onChanged: (_) => context.read<AuthViewModel>().clearError(),
                decoration: const InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF00695C)),
                ),
              ),
              const SizedBox(height: 10),

              // Error from ViewModel
              if (authVM.errorMessage.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(authVM.errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              authVM.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF00695C)))
                  : AppButton(label: 'Create Account', onTap: _onRegister),
              // "Create Account"

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Login',
                        style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Small helper to create label text (avoids repeating style)
  Widget _label(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));
}
