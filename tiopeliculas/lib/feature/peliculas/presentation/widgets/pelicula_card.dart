import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/pelicula_entity.dart';
import '../providers/peliculas_provider.dart';

class PeliculaCard extends StatelessWidget {
  final PeliculaEntity pelicula;
  final VoidCallback onEdit;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    required this.onEdit,
  });

  static const _genreColors = <String, List<Color>>{
    'Acción': [Color(0xFF7B1FA2), Color(0xFFE53935)],
    'Comedia': [Color(0xFFF57F17), Color(0xFFFF8F00)],
    'Drama': [Color(0xFF1565C0), Color(0xFF0288D1)],
    'Terror': [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    'Romance': [Color(0xFFAD1457), Color(0xFFE91E63)],
    'Ciencia Ficción': [Color(0xFF0D47A1), Color(0xFF1976D2)],
    'Animación': [Color(0xFFE65100), Color(0xFFF57C00)],
    'Documental': [Color(0xFF37474F), Color(0xFF546E7A)],
  };

  List<Color> _genreGradient(String genre) {
    for (final entry in _genreColors.entries) {
      if (genre.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return [const Color(0xFF37474F), const Color(0xFF546E7A)];
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Eliminar película?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de eliminar "${pelicula.titulo}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCF6679),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final ok =
          await context.read<PeliculasProvider>().deletePelicula(pelicula.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok
                ? '${pelicula.titulo} eliminada'
                : context.read<PeliculasProvider>().errorMessage ??
                    'Error al eliminar'),
            backgroundColor: ok
                ? const Color(0xFF2E7D32)
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _genreGradient(pelicula.genero);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Gradient header
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.movie_rounded,
                size: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Text(
                  pelicula.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Row(
                  children: [
                    Chip(
                      label: Text(pelicula.genero),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today_rounded,
                        size: 12, color: colors[1]),
                    const SizedBox(width: 4),
                    Text(
                      '${pelicula.anio}',
                      style: TextStyle(
                          color: colors[1],
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (pelicula.descripcion.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: Text(
                    pelicula.descripcion,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const Spacer(),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('Editar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white60,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 32, color: const Color(0xFF2A2A4A)),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_rounded, size: 16),
                      label: const Text('Eliminar'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFCF6679),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
