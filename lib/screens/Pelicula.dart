import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:proyecto/servicios/supabase_video_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pelicula extends StatefulWidget {
  final String titulo;
  final String descripcion;

  const Pelicula({
    Key? key,
    required this.titulo,
    required this.descripcion,
  }) : super(key: key);

  @override
  _PeliculaState createState() => _PeliculaState();
}

class _PeliculaState extends State<Pelicula> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _errorLoading = false;

  @override
  void initState() {
    super.initState();
    listarArchivos(); // Para ver los archivos reales
    cargarVideo();    // Para reproducir el video
  }

  Future<void> listarArchivos() async {
    final supabase = Supabase.instance.client;
    // Cambia el bucket a 'peliculas' y la ruta a 'videos'
    final response = await supabase.storage.from('peliculas').list(path: 'videos');
    print('📦 Archivos en la carpeta "peliculas/videos":');
    for (var item in response) {
      print('➡️ ${item.name}');
    }
  }

  Future<void> cargarVideo() async {
    try {
      // Cambia el bucket y la ruta del archivo correctamente
      final path = 'videos/videos2.mp4'; // carpeta 'videos' dentro del bucket 'peliculas' con archivo 'videos2.mp4'
      final urlFirmada = await obtenerUrlFirmada(path, bucket: 'peliculas');
      print('URL firmada: $urlFirmada');

      if (urlFirmada != null) {
        _videoPlayerController = VideoPlayerController.network(urlFirmada);
        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primaryYellow,
            handleColor: Colors.white,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.lightGreen,
          ),
        );

        setState(() {
          _isLoading = false;
          _errorLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorLoading = true;
        });
      }
    } catch (e) {
      print('Error al cargar el video: $e');
      setState(() {
        _isLoading = false;
        _errorLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Reproduciendo: ${widget.titulo}', style: AppTextStyles.subtitle),
        backgroundColor: AppColors.inputFill,
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.titulo, style: AppTextStyles.title.copyWith(fontSize: 24)),
            const SizedBox(height: 10),
            Text(widget.descripcion, style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorLoading)
              const Center(
                child: Text(
                  'No se pudo cargar el video.',
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            else if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized)
              AspectRatio(
                aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

