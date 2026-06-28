import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedMetric = 0;

  @override
  Widget build(BuildContext context) {
    final metric = AppData.healthMetrics[_selectedMetric];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Health Reports',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            SectionHeader(
              title: 'Health Metrics',
              actionLabel: 'This Week',
              onAction: () {},
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: AppData.healthMetrics.asMap().entries.map((e) {
                final m = e.value;
                final selected = _selectedMetric == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMetric = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: selected
                              ? AppColors.primary.withValues(alpha: (0.3))
                              : Colors.black.withValues(alpha: (0.05)),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.monitor_heart_outlined,
                                size: 18,
                                color: selected ? Colors.white70 : AppColors.primary),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withValues(alpha: (0.2))
                                    : AppColors.success.withValues(alpha: (0.1)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(m.status,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color:
                                        selected ? Colors.white : AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.value,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: selected ? Colors.white : AppColors.textDark,
                                )),
                            Text('${m.unit} • ${m.name}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: selected ? Colors.white70 : AppColors.textLight,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: (0.05)),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(metric.name,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            const Text('Weekly trend',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Text(metric.value,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                      Text(' ${metric.unit}',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textLight)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: AppColors.divider,
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (v, _) => Text(v.toInt().toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.textLight)),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) => Text(
                                  v.toInt() < days.length ? days[v.toInt()] : '',
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.textLight)),
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: metric.weeklyData.asMap().entries.map((e) =>
                                FlSpot(e.key.toDouble(), e.value)).toList(),
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: FlDotData(
                              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeColor: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primary.withValues(alpha: (0.2)),
                                  AppColors.primary.withValues(alpha: (0.0)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent reports
            const SectionHeader(title: 'Recent Reports'),
            const SizedBox(height: 14),
            ..._recentReports.map((r) => _ReportTile(report: r)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static const _recentReports = [
    {'title': 'ECG Report', 'date': '15 May 2025', 'type': 'Electrocardiogram', 'status': 'Normal'},
    {'title': 'Blood Panel', 'date': '10 May 2025', 'type': 'Laboratory', 'status': 'Reviewed'},
    {'title': 'Echocardiogram', 'date': '02 May 2025', 'type': 'Imaging', 'status': 'Normal'},
    {'title': 'TMT Stress Test', 'date': '25 Apr 2025', 'type': 'Stress Test', 'status': 'Good'},
  ];
}

class _ReportTile extends StatelessWidget {
  final Map<String, String> report;
  const _ReportTile({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: (0.04)),
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
            child: const Icon(Icons.description_outlined,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['title']!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                Text('${report['type']} • ${report['date']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: (0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(report['status']!,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: AppColors.textLight),
        ],
      ),
    );
  }
}