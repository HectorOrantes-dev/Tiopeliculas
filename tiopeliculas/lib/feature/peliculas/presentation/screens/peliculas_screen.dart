import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../feature/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/pelicula_entity.dart';
import '../providers/peliculas_provider.dart';
import '../widgets/pelicula_card.dart';
import 'pelicula_form_screen.dart';

class PeliculasScreen extends StatefulWidget {
  const PeliculasScreen({super.key});

  @override
  State<PeliculasScreen> createState() => _PeliculasScreenState();
}

class _PeliculasScreenState extends State<PeliculasScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<PeliculasProvider>().loadPeliculas();
    });
  }

  void _goToForm(BuildContext context, {PeliculaEntity? pelicula}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeliculaFormScreen(pelicula: pelicula),
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A2E),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              title: Row(
                children: [
                  Icon(Icons.movie_filter_rounded,
                      color: cs.primary, size: 22),
                  const SizedBox(width: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [cs.primary, cs.secondary],
                    ).createShader(bounds),
                    child: const Text(
                      'TIOPELICULAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A0808),
                      const Color(0xFF1A1A2E),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.movie_rounded,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Cerrar sesión',
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.white70),
              ),
            ],
          ),
          Consumer<PeliculasProvider>(
            builder: (_, provider, _) {
              if (provider.isLoading && provider.peliculas.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (provider.hasError && provider.peliculas.isEmpty) {
                return SliverFillRemaining(
                  child: _ErrorView(
                    message: provider.errorMessage ?? 'Error desconocido',
                    onRetry: () => provider.loadPeliculas(),
                  ),
                );
              }

              if (provider.peliculas.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyView(
                    onAdd: () => _goToForm(context),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final p = provider.peliculas[i];
                      return PeliculaCard(
                        pelicula: p,
                        onEdit: () => _goToForm(context, pelicula: p),
                      );
                    },
                    childCount: provider.peliculas.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Añadir'),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_creation_outlined,
                size: 80, color: cs.primary.withValues(alpha: 0.5)),
            const SizedBox(height: 20),
            const Text(
              'Tu catálogo está vacío',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega tu primera película para comenzar',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Agregar película'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 64, color: Colors.white38),
            const SizedBox(height: 16),
            const Text(
              'No se pudo conectar',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
