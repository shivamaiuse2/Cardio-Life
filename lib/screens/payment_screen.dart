import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class PaymentScreen extends StatefulWidget {
  final Appointment appointment;
  const PaymentScreen({super.key, required this.appointment});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _processing = false;

  final _methods = [
    ('Credit / Debit Card', Icons.credit_card_rounded, '•••• 4242'),
    ('PayPal', Icons.account_balance_wallet_outlined, 'alex.morgan@email.com'),
    ('Apple Pay', Icons.apple_rounded, 'Touch ID or Face ID'),
    ('Insurance', Icons.health_and_safety_outlined, 'Cover via provider'),
  ];

  void _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _processing = false);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _SuccessSheet(appointment: widget.appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.appointment.doctor.consultationFee;
    final tax = fee * 0.05;
    final total = fee + tax;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Order summary
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(widget.appointment.doctor.avatarUrl)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.appointment.doctor.name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                Text(widget.appointment.doctor.specialty,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 14),
                      _row('Consultation Fee', '\$${fee.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _row('Service Tax (5%)', '\$${tax.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 8),
                      _row('Total Amount', '\$${total.toStringAsFixed(2)}', bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Select Payment Method',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 14),
                ..._methods.asMap().entries.map((e) {
                  final sel = _selectedMethod == e.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMethod = e.key),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: sel ? AppColors.primary : AppColors.divider, width: sel ? 1.5 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.lightRed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(e.value.$2, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value.$1,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(e.value.$3,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                              ],
                            ),
                          ),
                          Icon(
                            sel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: sel ? AppColors.primary : AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _processing ? null : _pay,
                child: _processing
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text('Pay \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: bold ? 14 : 13,
                color: bold ? AppColors.textDark : AppColors.textMedium,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                fontSize: bold ? 16 : 13,
                color: bold ? AppColors.primary : AppColors.textDark,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  final Appointment appointment;
  const _SuccessSheet({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 56),
          ),
          const SizedBox(height: 24),
          const Text('Payment Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Your appointment with ${appointment.doctor.name} is confirmed.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/appointment-detail',
                  arguments: appointment,
                );
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}