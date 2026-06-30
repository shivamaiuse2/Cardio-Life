import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final typeLabels = {
      AppointmentType.initialConsultation: 'Initial Consultation',
      AppointmentType.followUp: 'Follow-up Consultation',
      AppointmentType.checkup: 'General Checkup',
      AppointmentType.testScan: 'Test & Scan',
    };
    final typeDuration = {
      AppointmentType.initialConsultation: '30 min',
      AppointmentType.followUp: '20 min',
      AppointmentType.checkup: '45 min',
      AppointmentType.testScan: '60 min',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: AppColors.textDark),
            title: const Text('Appointment Details',
                style: TextStyle(color: AppColors.textDark, fontSize: 16)),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date badge
                  Text(
                    '${appointment.date.day} ${_month(appointment.date.month)} ${appointment.date.year}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
  
                  // Doctor card with large avatar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: (0.06)),
                            blurRadius: 12,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appointment.doctor.specialty,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(appointment.doctor.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.chipBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    'Appt ID: ${appointment.appointmentId}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMedium)),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            appointment.doctor.avatarUrl,
                            width: 80,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 90,
                              color: AppColors.lightRed,
                              child: const Icon(Icons.person_rounded,
                                  size: 40, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Appointment status
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: (0.05)),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Appointment Status',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            StatusBadge(status: appointment.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _DateTimeBox(
                              label:
                                  '${appointment.date.day} ${_month(appointment.date.month)} ${appointment.date.year}',
                              sub: 'Date',
                              icon: Icons.calendar_today_outlined,
                            ),
                            const SizedBox(width: 12),
                            _DateTimeBox(
                              label: appointment.timeSlot,
                              sub: 'Time',
                              icon: Icons.access_time_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visit type section
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: (0.05)),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Visit Type',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.lightRed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_rounded,
                                  color: AppColors.primary, size: 18),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.chipBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.search_rounded,
                                  color: AppColors.textLight, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _VisitTypeCard(
                                label: typeLabels[appointment.type]!,
                                duration: typeDuration[appointment.type]!,
                                isSelected: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _VisitTypeCard(
                                label: appointment.type ==
                                        AppointmentType.initialConsultation
                                    ? 'Follow-up\nConsultation'
                                    : 'Initial\nConsultation',
                                duration: appointment.type ==
                                        AppointmentType.initialConsultation
                                    ? '20 min'
                                    : '30 min',
                                isSelected: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What to Expect
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: (0.05)),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('What to Expect',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ExpectItem(
                              icon: Icons.health_and_safety_outlined,
                              label: 'Heart\nCheckup',
                              color: Color(0xFFEF5350),
                            ),
                            _ExpectItem(
                              icon: Icons.graphic_eq_rounded,
                              label: 'ECG\nTest',
                              color: Color(0xFF42A5F5),
                            ),
                            _ExpectItem(
                              icon: Icons.show_chart_rounded,
                              label: 'Risk\nAssessment',
                              color: Color(0xFF66BB6A),
                            ),
                            _ExpectItem(
                              icon: Icons.medication_liquid_outlined,
                              label: 'Personalised\nTreatment',
                              color: Color(0xFFFFA726),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Care info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightRed,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_rounded,
                            color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Caring for your heart,',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark)),
                              Text('every step of the way.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMedium)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Learn More',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  if (appointment.status == AppointmentStatus.confirmed ||
                      appointment.status == AppointmentStatus.pending)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context
                                  .read<AppState>()
                                  .cancelAppointment(appointment.id);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, '/doctor',
                                arguments: appointment.doctor),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Reschedule'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m - 1];
  }
}

class _DateTimeBox extends StatelessWidget {
  final String label;
  final String sub;
  final IconData icon;

  const _DateTimeBox(
      {required this.label, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                  overflow: TextOverflow.ellipsis),
              Text(sub,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisitTypeCard extends StatelessWidget {
  final String label;
  final String duration;
  final bool isSelected;

  const _VisitTypeCard({
    required this.label,
    required this.duration,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lightRed : AppColors.chipBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: (0.3))
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textMedium,
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(duration,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? AppColors.textDark : AppColors.textLight,
                  )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpectItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ExpectItem(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: (0.12)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textMedium, height: 1.4)),
      ],
    );
  }
}
