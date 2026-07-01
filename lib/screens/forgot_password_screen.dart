import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _send() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() { _loading = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: _sent ? _SuccessView(email: _emailCtrl.text.trim(), onBack: () => Navigator.pop(context)) : _FormView(
          ctrl: _emailCtrl,
          loading: _loading,
          onSend: _send,
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController ctrl;
  final bool loading;
  final VoidCallback onSend;
  const _FormView({required this.ctrl, required this.loading, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(color: AppColors.lightRed, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 34),
        ),
        const SizedBox(height: 24),
        const Text('Forgot Password?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 8),
        const Text("No worries! Enter your email and we'll send you reset instructions.",
            style: TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5)),
        const SizedBox(height: 32),
        const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textLight, size: 20),
            filled: true, fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: loading ? null : onSend,
            child: loading
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text('Back to Sign In',
                  style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onBack;
  const _SuccessView({required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 52),
        ),
        const SizedBox(height: 28),
        const Text('Check Your Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 12),
        Text("We've sent a password reset link to\n$email",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5)),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/reset-password'),
            child: const Text('Open Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onBack,
          child: const Text("Back to Sign In",
              style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
        ),
      ],
    );
  }
}