import 'package:flutter/material.dart';
import 'package:proyecto/screens/Pelicula.dart';
import 'package:proyecto/screens/Trailer.dart';
import 'package:proyecto/servicios/tmdb_service.dart';
import 'package:proyecto/widgets/Mydrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Para el trailer embebido

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
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
      setState(() {
        peliculas = resultado;
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
            final trailerUrl = await tmdbService.getTrailerYoutubeUrl(pelicula['id']);

            if (trailerUrl != null) {
              Navigator.pop(context); // Cierra el diálogo aquí
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Trailer(
                    titulo: titulo,
                    descripcion: descripcion,
                    generos: [], // agrega tus géneros si quieres
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Catálogo de Películas', style: AppTextStyles.subtitle),
        backgroundColor: AppColors.inputFill,
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      drawer: MyDrawer(parentContext: context),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: peliculas.length,
                itemBuilder: (context, index) {
                  final pelicula = peliculas[index];
                  final titulo = pelicula['title'] ?? 'Sin título';
                  final descripcion = pelicula['overview'] ?? 'Sin descripción';
                  final posterPath = pelicula['poster_path'];
                  final releaseDate = pelicula['release_date'] ?? '';

                  return GestureDetector(
                    onTap: () => mostrarDialogoPelicula(pelicula),
                    child: Card(
                      color: AppColors.inputFill,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                if (posterPath != null)
                                  CachedNetworkImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primaryYellow)),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: AppColors.textWhite),
                                  )
                                else
                                  Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.movie,
                                          size: 50, color: Colors.grey[600]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              titulo,
                              style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (releaseDate.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                releaseDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
