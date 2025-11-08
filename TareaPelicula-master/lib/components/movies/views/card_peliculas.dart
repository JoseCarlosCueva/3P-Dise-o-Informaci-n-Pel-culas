import 'package:flutter/material.dart';
import 'package:get/get.dart';
// removed unnecessary direct internal import
import 'package:peliculas_/components/movies/models/peliculas_model.dart';
import 'package:peliculas_/components/movies/views/pelicula_detalle_view.dart';

class CardPeliculas extends StatelessWidget {
  const CardPeliculas({super.key, required this.peliculasModel});
  final PeliculasModel peliculasModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      color: cardColor, // adapted to theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.all(9),
      shadowColor: theme.shadowColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${peliculasModel.posterPath}',
                ),
                const SizedBox(height: 8),
                Text(
                  peliculasModel.title,
                  style:
                      titleStyle ??
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  peliculasModel.overview,
                  style:
                      bodyStyle ??
                      const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => PeliculaDetalleView(pelicula: peliculasModel));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primary.withAlpha(20),
                    foregroundColor: primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Ver más',
                    style: TextStyle(
                      // color is provided by foregroundColor
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
