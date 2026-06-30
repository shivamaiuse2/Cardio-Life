import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ─── Avatar Widget ────────────────────────────────────────────────────────────
class DoctorAvatar extends StatelessWidget {
  final String url;
  final double radius;

  const DoctorAvatar({super.key, required this.url, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightRed,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (_, __) {},
      child: null,
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (status) {
      AppointmentStatus.confirmed => (
          'Confirmed',
          AppColors.success,
          const Color(0xFFECFDF5)
        ),
      AppointmentStatus.pending => (
          'Pending',
          AppColors.warning,
          const Color(0xFFFFFBEB)
        ),
      AppointmentStatus.cancelled => (
          'Cancelled',
          Colors.red,
          const Color(0xFFFFF0F0)
        ),
      AppointmentStatus.completed => (
          'Completed',
          AppColors.info,
          const Color(0xFFEFF6FF)
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Rating Stars ─────────────────────────────────────────────────────────────
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded, color: Colors.amber, size: size);
        } else if (i < rating) {
          return Icon(Icons.star_half_rounded, color: Colors.amber, size: size);
        }
        return Icon(Icons.star_outline_rounded,
            color: Colors.grey[300], size: size);
      }),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader(
      {super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionLabel!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

// ─── Doctor Card ──────────────────────────────────────────────────────────────
class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;
  final bool isFav;
  final VoidCallback onFav;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.isFav,
    required this.onFav,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: (0.06)),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                DoctorAvatar(url: doctor.avatarUrl, radius: 32),
                if (doctor.isAvailable)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(doctor.specialty,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingStars(rating: doctor.rating),
                      const SizedBox(width: 4),
                      Text('${doctor.rating} (${doctor.reviewCount})',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.local_hospital_outlined,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(doctor.hospital,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textLight),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: onFav,
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.primary : AppColors.textLight,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text('\$${doctor.consultationFee.toInt()}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom Bottom Nav ────────────────────────────────────────────────────────
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (
        Icons.calendar_month_rounded,
        Icons.calendar_month_outlined,
        'Appointments'
      ),
      (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Reports'),
      (Icons.person_rounded, Icons.person_outlined, 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: (0.08)),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = currentIndex == i;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: (0.1))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? items[i].$1 : items[i].$2,
                        color:
                            selected ? AppColors.primary : AppColors.textLight,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Appointment Card ─────────────────────────────────────────────────────────
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: (0.06)),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                DoctorAvatar(url: appointment.doctor.avatarUrl, radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.doctor.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(appointment.doctor.specialty,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
                StatusBadge(status: appointment.status),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoChip(Icons.calendar_today_outlined,
                    '${appointment.date.day} ${_month(appointment.date.month)} ${appointment.date.year}'),
                const SizedBox(width: 12),
                _infoChip(Icons.access_time_outlined, appointment.timeSlot),
              ],
            ),
            if (appointment.status != AppointmentStatus.cancelled &&
                appointment.status != AppointmentStatus.completed) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text('View Details',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 5),
        Text(text,
            style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
      ],
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

// ─── Service Tile ─────────────────────────────────────────────────────────────
class ServiceTile extends StatelessWidget {
  final MedicalService service;
  final VoidCallback onBook;

  const ServiceTile({super.key, required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final iconData = _iconFor(service.iconPath);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: (0.05)),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lightRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(service.center,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textLight)),
                const SizedBox(height: 4),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,
                            size: 11, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(service.timeSlot,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textMedium)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                              color: AppColors.textLight,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text('${service.slotsAvailable} Slots available',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.success)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${service.price.toInt()}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onBook,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String key) {
    return switch (key) {
      'heart' => Icons.favorite_rounded,
      'echo' => Icons.graphic_eq_rounded,
      'tmt' => Icons.directions_run_rounded,
      'checkup' => Icons.health_and_safety_rounded,
      'blood' => Icons.water_drop_rounded,
      _ => Icons.medical_services_rounded,
    };
  }
}
