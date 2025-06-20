import 'package:flutter/material.dart';
import 'package:proyecto/screens/Pelicula.dart';
import 'package:proyecto/screens/Trailer.dart';
import 'package:proyecto/servicios/tmdb_service.dart';
import 'package:proyecto/widgets/MenorDrawer.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class MenorEdad extends StatefulWidget {
  @override
  _EdadState createState() => _EdadState();
}

class _EdadState extends State<MenorEdad> {
  List<dynamic> peliculas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPeliculas();
  }

  void cargarPeliculas() async {
    final servicio = TMDBService();
    try {
      final resultado = await servicio.getPopularMovies();
      final List<int> generosInfantiles = [16, 10751, 14, 12];

      final filtradas = resultado.where((pelicula) {
        final generos = List<int>.from(pelicula['genre_ids'] ?? []);
        return generos.any((id) => generosInfantiles.contains(id));
      }).toList();

      setState(() {
        peliculas = filtradas;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar películas: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void mostrarDialogoPelicula(Map<String, dynamic> pelicula) async {
    final titulo = pelicula['title'] ?? 'Sin título';
    final descripcion = pelicula['overview'] ?? 'Sin descripción';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.inputFill,
        title: Text(titulo, style: AppTextStyles.subtitle),
        content: Text(descripcion, style: AppTextStyles.subtitle),
        actions: [
          TextButton(
            onPressed: () async {
              final tmdbService = TMDBService();
              final trailerUrl =
                  await tmdbService.getTrailerYoutubeUrl(pelicula['id']);

              Navigator.pop(context);

              if (trailerUrl != null && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Trailer(
                      titulo: titulo,
                      descripcion: descripcion,
                      generos: [],
                      youtubeUrl: trailerUrl,
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Trailer no disponible"),
                    content: Text("No se encontró trailer para esta película."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cerrar"),
                      )
                    ],
                  ),
                );
              }
            },
            child: Text("Ver Trailer", style: AppTextStyles.link),
          ),
          ElevatedButton(
            style: AppButtonStyle.yellowButton,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Pelicula(titulo: titulo, descripcion: descripcion),
                ),
              );
            },
            child: Text("Ver Ahora"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Películas infantiles"),
        backgroundColor: AppColors.primaryYellow,
      ),
      drawer: MenorDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.6),
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final pelicula = peliculas[index];
                return GestureDetector(
                  onTap: () => mostrarDialogoPelicula(pelicula),
                  child: Card(
                    color: AppColors.inputFill,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${pelicula['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pelicula['title'] ?? 'Sin título',
                            style: AppTextStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
