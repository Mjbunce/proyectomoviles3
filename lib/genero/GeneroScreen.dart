import 'package:flutter/material.dart';
import 'package:proyecto/screens/tmdb_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:proyecto/widgets/Mydrawer.dart';
import 'package:proyecto/screens/Trailer.dart'; 

class GeneroScreen extends StatefulWidget {
  final String titulo;
  final int genreId;

  const GeneroScreen({required this.titulo, required this.genreId});

  @override
  _GeneroScreenState createState() => _GeneroScreenState();
}

class _GeneroScreenState extends State<GeneroScreen> {
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
      final resultado = await servicio.getMoviesByGenre(widget.genreId);
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
                Navigator.pop(context); // Cierra el diálogo
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Trailer(
                      titulo: titulo,
                      descripcion: descripcion,
                      generos: [], // Puedes agregar géneros si tienes
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
              // lógica de Ver Ahora (opcional)
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
        title: Text(widget.titulo, style: AppTextStyles.subtitle),
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
                            child: posterPath != null
                                ? CachedNetworkImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryYellow)),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: AppColors.textWhite),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.movie, size: 50, color: Colors.grey[600]),
                                    ),
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
                                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
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
