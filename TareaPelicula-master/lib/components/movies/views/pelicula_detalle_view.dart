import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/peliculas_model.dart';

class PeliculaDetalleView extends StatelessWidget {
  final PeliculasModel pelicula;

  const PeliculaDetalleView({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // ensure we don't use deprecated background; prefer surface for light/dark
    final imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final imageUrl = (pelicula.backdropPath.isNotEmpty)
        ? '$imageBaseUrl${pelicula.backdropPath}'
        : (pelicula.posterPath.isNotEmpty
              ? '$imageBaseUrl${pelicula.posterPath}'
              : null);

    final contentColor = isDark ? Colors.white : Colors.black87;
    final contentSecondary = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          pelicula.title,
          style:
              theme.textTheme.titleMedium?.copyWith(color: contentColor) ??
              TextStyle(
                color: contentColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
        iconTheme: IconThemeData(color: contentColor),
      ),
      body: Stack(
        children: [
          // Fondo: imagen difuminada + gradiente
          if (imageUrl != null)
            SizedBox(
              height: 320,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: theme.colorScheme.background),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: isDark
                          ? Colors.black.withAlpha(76)
                          : Colors.white.withAlpha(76),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isDark
                              ? Colors.black.withAlpha(178)
                              : Colors.white.withAlpha(178),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Contenido desplazable
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 220, bottom: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Tarjeta glassmorphism con información
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withAlpha(10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.dividerColor.withAlpha(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            Text(
                              pelicula.title,
                              style:
                                  theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: contentColor,
                                  ) ??
                                  TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: contentColor,
                                  ),
                            ),
                            const SizedBox(height: 8),

                            // Meta info: original title / language
                            Text(
                              "${pelicula.originalTitle} • ${pelicula.originalLanguage.toUpperCase()}",
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                    color: contentSecondary,
                                  ) ??
                                  TextStyle(color: contentSecondary),
                            ),
                            const SizedBox(height: 12),

                            // Row con iconos y datos
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                  icon: Icons.date_range,
                                  label: pelicula.releaseDate
                                      .toIso8601String()
                                      .split('T')[0],
                                ),
                                _InfoChip(
                                  icon: Icons.star,
                                  label: pelicula.voteAverage.toStringAsFixed(
                                    1,
                                  ),
                                ),
                                _InfoChip(
                                  icon: Icons.trending_up,
                                  label: pelicula.popularity.toStringAsFixed(1),
                                ),
                                _InfoChip(
                                  icon: Icons.people,
                                  label: '${pelicula.voteCount} votos',
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Descripción',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pelicula.overview.isNotEmpty
                                  ? pelicula.overview
                                  : 'Sin descripción disponible.',
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                    color: contentSecondary,
                                  ) ??
                                  TextStyle(
                                    color: contentSecondary,
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Espacio para futuros botones (por ejemplo ver trailer, compartir)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Volver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Poster circular superpuesto
          if (imageUrl != null)
            Positioned(
              top: 160,
              left: 24,
              child: Hero(
                tag: pelicula.id.toString(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withAlpha(153)
                              : Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Small reusable chip used in the details card
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({Key? key, required this.icon, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chipTextColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color ?? chipTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
