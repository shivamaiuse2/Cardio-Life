import 'package:cardiolife/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'utils/app_state.dart';
import 'models/models.dart';
import 'screens/appointment_detail_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/doctors_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/search_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

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
          case '/onboarding':
            return _route(const OnboardingScreen());
          case '/login':
            return _route(const LoginScreen());
          case '/signup':
            return _route(const SignupScreen());
          case '/otp':
            return _route(const OtpScreen());
          case '/forgot-password':
            return _route(const ForgotPasswordScreen());
          case '/home':
            return _route(
              const MainShell(),
              extra: (ctx) => ctx.read<AppState>().setIndex(0),
            );
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
          case '/profile':
            return _route(
              const MainShell(),
              extra: (ctx) => ctx.read<AppState>().setIndex(3),
            );
          case '/appointments':
            return _route(const AppointmentsScreen());
          case '/search':
            return _route(const SearchScreen());
          case '/doctor':
            final doctor = settings.arguments;
            if (doctor is Doctor) {
              return _route(DoctorDetailScreen(doctor: doctor));
            }
            return _route(const DoctorsScreen());
          case '/appointment-detail':
            final appointment = settings.arguments;
            if (appointment is Appointment) {
              return _route(AppointmentDetailScreen(appointment: appointment));
            }
            return _route(const AppointmentsScreen());
          case '/payment':
            final appointment = settings.arguments;
            if (appointment is Appointment) {
              return _route(PaymentScreen(appointment: appointment));
            }
            return _route(PaymentScreen(appointment: AppData.appointments.first));
          case '/chat':
            final doctor = settings.arguments;
            if (doctor is Doctor) {
              return _route(ChatScreen(doctor: doctor));
            }
            return _route(ChatScreen(doctor: AppData.doctors.first));
          case '/doctors':
            return _route(const DoctorsScreen());
          case '/notifications':
            return _route(const NotificationsScreen());
          case '/edit-profile':
            return _route(const EditProfileScreen());
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