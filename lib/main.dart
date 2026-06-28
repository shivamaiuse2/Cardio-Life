import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'utils/app_state.dart';
import 'models/models.dart';
import 'screens/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/appointment_detail_screen.dart';
import 'screens/doctors_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CardioLifeApp(),
    ),
  );
}

class CardioLifeApp extends StatelessWidget {
  const CardioLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioLife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _route(const SplashScreen());
          case '/home':
            return _route(const MainShell());
          case '/book':
            return _route(
              const MainShell(),
              extra: (ctx) => ctx.read<AppState>().setIndex(1),
            );
          case '/reports':
            return _route(
              const MainShell(),
              extra: (ctx) => ctx.read<AppState>().setIndex(2),
            );
          case '/doctor':
            final doctor = settings.arguments as Doctor;
            return _route(DoctorDetailScreen(doctor: doctor));
          case '/appointment-detail':
            final appointment = settings.arguments as Appointment;
            return _route(AppointmentDetailScreen(appointment: appointment));
          case '/doctors':
            return _route(const DoctorsScreen());
          default:
            return _route(const SplashScreen());
        }
      },
    );
  }

  PageRoute _route(Widget page, {void Function(BuildContext)? extra}) {
    return PageRouteBuilder(
      pageBuilder: (ctx, animation, _) {
        if (extra != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => extra(ctx));
        }
        return page;
      },
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}