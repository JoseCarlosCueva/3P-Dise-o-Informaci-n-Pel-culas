import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peliculas_/components/movies/controllers/peliculas_controller.dart';
import 'package:peliculas_/components/movies/views/card_peliculas.dart';

class PeliculasView extends StatelessWidget {
  PeliculasView({super.key});

  final PeliculasController peliculasController = Get.put<PeliculasController>(
    PeliculasController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        elevation: 2,
        shadowColor: const Color.fromARGB(255, 34, 51, 238).withAlpha(60),
        centerTitle: true,
        title: Text(
          '🎬Las Películas Mas Populares HN',
          style:
              Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold) ??
              const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            tooltip: Get.isDarkMode ? 'Cambiar a claro' : 'Cambiar a oscuro',
            icon: Icon(Get.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
        ],
      ),
      body: Obx(
        () => peliculasController.cargando
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 4,
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFF0F2F5)],
                  ),
                  // background claro
                ),
                child: GetBuilder<PeliculasController>(
                  init: peliculasController,
                  builder: (controller) {
                    if (controller.listaPeliculas.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay películas disponibles 🍿',
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.listaPeliculas.length,
                      itemBuilder: (context, index) {
                        final pelicula = controller.listaPeliculas[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: pelicula.id,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CardPeliculas(peliculasModel: pelicula),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
