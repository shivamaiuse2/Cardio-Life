import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final upcoming = state.appointments
        .where((a) =>
            a.status == AppointmentStatus.confirmed ||
            a.status == AppointmentStatus.pending)
        .take(1)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B0000), Color(0xFFB71C1C)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 28,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning,',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: (0.8)),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              state.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(state.user.avatarUrl),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red[300],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(
                                child: Text('2',
                                    style: TextStyle(fontSize: 8, color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search bar
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: (0.15)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: (0.2)),
                      ),),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded,
                              color: Colors.white.withValues(alpha: (0.7)), size: 20),
                          const SizedBox(width: 10),
                          Text('Search doctors, services...',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: (0.6)), fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health metrics cards
                  SectionHeader(
                    title: 'Health Overview',
                    actionLabel: 'See All',
                    onAction: () => Navigator.pushNamed(context, '/reports'),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppData.healthMetrics.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final m = AppData.healthMetrics[i];
                        return _HealthMetricCard(metric: m);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick actions
                  const Text('Quick Actions',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.calendar_month_rounded,
                        label: 'Book\nAppointment',
                        color: AppColors.primary,
                        onTap: () => Navigator.pushNamed(context, '/book'),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.science_outlined,
                        label: 'Lab\nTests',
                        color: const Color(0xFF1565C0),
                        onTap: () => Navigator.pushNamed(context, '/book'),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.medical_information_outlined,
                        label: 'My\nReports',
                        color: const Color(0xFF2E7D32),
                        onTap: () => Navigator.pushNamed(context, '/reports'),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.emergency_outlined,
                        label: 'Emergency',
                        color: const Color(0xFFE65100),
                        onTap: () => _showEmergency(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Upcoming appointment
                  if (upcoming.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Upcoming Appointment',
                      actionLabel: 'View All',
                      onAction: () {},
                    ),
                    const SizedBox(height: 14),
                    _UpcomingCard(appointment: upcoming.first),
                    const SizedBox(height: 24),
                  ],

                  // Top Doctors
                  SectionHeader(
                    title: 'Top Cardiologists',
                    actionLabel: 'See All',
                    onAction: () => Navigator.pushNamed(context, '/doctors'),
                  ),
                  const SizedBox(height: 14),
                  ...AppData.doctors.take(3).map((d) => DoctorCard(
                        doctor: d,
                        isFav: state.isFavorite(d),
                        onFav: () => state.toggleFavorite(d),
                        onTap: () => Navigator.pushNamed(context, '/doctor', arguments: d),
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.emergency_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Emergency Contact'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Call emergency services or our 24/7 cardiac helpline.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Call 911'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.favorite_rounded, color: AppColors.primary),
              label: const Text('Cardiac Helpline: 1800-HEART',
                  style: TextStyle(color: AppColors.primary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthMetricCard extends StatelessWidget {
  final HealthMetric metric;
  const _HealthMetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: (0.06)), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.monitor_heart_outlined,
                    color: AppColors.primary, size: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: (0.1)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(metric.status,
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.success, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Spacer(),
          Text(metric.value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          Text(metric.unit,
              style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
          const SizedBox(height: 2),
          Text(metric.name,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMedium, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: (0.1)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: (0.15))),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                    height: 1.3,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final Appointment appointment;
  const _UpcomingCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B0000), Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: (0.3)),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(appointment.doctor.avatarUrl),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.doctor.name,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                Text(appointment.doctor.specialty,
                    style: TextStyle(color: Colors.white.withValues(alpha: (0.7)), fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 12),
                    const SizedBox(width: 5),
                    Text(
                      '${appointment.date.day} ${_month(appointment.date.month)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time_outlined, color: Colors.white70, size: 12),
                    const SizedBox(width: 5),
                    Text(appointment.timeSlot,
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: (0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}