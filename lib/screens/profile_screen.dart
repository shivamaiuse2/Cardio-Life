import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('My Profile',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B0000), Color(0xFFB71C1C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage(user.avatarUrl),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primary, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded,
                                    color: AppColors.primary, size: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              Text(user.email,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: (0.75)),
                                      fontSize: 12)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: (0.2)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Patient',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health info cards
                  Row(
                    children: [
                      _InfoCard(label: 'Age', value: '${user.age} yrs', icon: Icons.cake_outlined),
                      const SizedBox(width: 12),
                      _InfoCard(label: 'Blood', value: user.bloodGroup, icon: Icons.water_drop_outlined),
                      const SizedBox(width: 12),
                      _InfoCard(label: 'Height', value: '${user.height.toInt()} cm', icon: Icons.height_rounded),
                      const SizedBox(width: 12),
                      _InfoCard(label: 'Weight', value: '${user.weight.toInt()} kg', icon: Icons.monitor_weight_outlined),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Appointments summary
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: (0.05),),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(
                            value: state.appointments.length.toString(),
                            label: 'Total'),
                        _vDivider(),
                        _Stat(
                            value: state.appointments
                                .where((a) => a.status == AppointmentStatus.completed)
                                .length
                                .toString(),
                            label: 'Completed'),
                        _vDivider(),
                        _Stat(
                            value: state.appointments
                                .where((a) =>
                                    a.status == AppointmentStatus.confirmed ||
                                    a.status == AppointmentStatus.pending)
                                .length
                                .toString(),
                            label: 'Upcoming'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menu sections
                  _MenuSection(
                    title: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Personal Information',
                        onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                      ),
                      _MenuItem(
                        icon: Icons.favorite_border_rounded,
                        label: 'Saved Doctors',
                        badge: '${state.favorites.length}',
                        onTap: () => Navigator.pushNamed(context, '/doctors'),
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none_rounded,
                        label: 'Notifications',
                        onTap: () => Navigator.pushNamed(context, '/notifications'),
                      ),
                      _MenuItem(
                        icon: Icons.payment_outlined,
                        label: 'Payment Methods',
                        onTap: () {
                          final appointment = state.appointments.isNotEmpty
                              ? state.appointments.first
                              : AppData.appointments.first;
                          Navigator.pushNamed(context, '/payment', arguments: appointment);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Health',
                    items: [
                      _MenuItem(
                        icon: Icons.medical_information_outlined,
                        label: 'Medical History',
                        onTap: () => Navigator.pushNamed(context, '/reports'),
                      ),
                      _MenuItem(
                        icon: Icons.medication_outlined,
                        label: 'Prescriptions',
                        onTap: () => Navigator.pushNamed(context, '/reports'),
                      ),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        label: 'Lab Reports',
                        onTap: () => Navigator.pushNamed(context, '/reports'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Support',
                    items: [
                      _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & FAQ', onTap: () {}),
                      _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                      _MenuItem(icon: Icons.info_outline_rounded, label: 'About CardioLife', onTap: () {}),
                      _MenuItem(
                        icon: Icons.logout_rounded,
                        label: 'Sign Out',
                        textColor: Colors.red,
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (r) => false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: (0.05)),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(label,
                style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
      ],
    );
  }
}

Widget _vDivider() =>
    Container(width: 1, height: 40, color: AppColors.divider);

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textLight)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: (0.04)),
                  blurRadius: 8,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final last = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!last)
                    const Divider(height: 1, indent: 56, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final Color? textColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (textColor ?? AppColors.primary).withValues(alpha: (0.1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: textColor ?? AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? AppColors.textDark,
                  )),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge!,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: textColor?.withValues(alpha: (0.5)) ?? AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
