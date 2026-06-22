import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/app_di.dart';
import 'core/theme/app_theme.dart';
import 'feature/auth/di/auth_di.dart';
import 'feature/auth/presentation/providers/auth_provider.dart';
import 'feature/auth/presentation/screens/login_screen.dart';
import 'feature/peliculas/di/peliculas_di.dart';
import 'feature/peliculas/presentation/providers/peliculas_provider.dart';
import 'feature/peliculas/presentation/screens/peliculas_screen.dart';

class TioPeliculasApp extends StatelessWidget {
  const TioPeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyección de dependencias manual
    AppDI.tokenStorage; // ensure initialized
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthDI.authProvider,
        ),
        ChangeNotifierProvider<PeliculasProvider>(
          create: (_) => PeliculasDI.peliculasProvider,
        ),
      ],
      child: MaterialApp(
        title: 'TioPeliculas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        // Punto de entrada reactivo según estado de autenticación
        home: Consumer<AuthProvider>(
          builder: (_, auth, _) {
            return auth.isAuthenticated
                ? const PeliculasScreen()
                : const LoginScreen();
          },
        ),
        // Navegación 1.0 — rutas auxiliares
        routes: {
          '/login': (_) => const LoginScreen(),
          '/peliculas': (_) => const PeliculasScreen(),
        },
      ),
    );
  }
}
