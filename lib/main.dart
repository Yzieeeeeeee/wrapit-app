import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';
import 'package:wrapit/screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WrapItApp());
}

class WrapItApp extends StatelessWidget {
  const WrapItApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    // ScreenUtilInit wraps the entire app so that .w / .h / .sp / .r
    // extensions are available everywhere and scale to every screen size.
    // Design size = 390 x 844 (iPhone 14 Pro — a common design baseline).
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AppStateProvider(
          state: appState,
          child: MaterialApp(
            title: 'Wrap It',
            debugShowCheckedModeBanner: false,
            theme: wrapItTheme(),
            home: const AuthScreen(),
          ),
        );
      },
    );
  }
}
