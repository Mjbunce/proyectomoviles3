import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:proyecto/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class Trailer extends StatefulWidget {
  final String titulo;
  final String descripcion;
  final List<String> generos;
  final String youtubeUrl;

  const Trailer({
    required this.titulo,
    required this.descripcion,
    required this.generos,
    required this.youtubeUrl,
  });

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<Trailer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  Future<void> _launchYoutube() async {
    final url = Uri.parse(widget.youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir YouTube')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Ver Trailer", style: AppTextStyles.subtitle),
        backgroundColor: AppColors.inputFill,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.titulo, style: AppTextStyles.title.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text(widget.descripcion, style: AppTextStyles.subtitle),
              const SizedBox(height: 12),
              Text("Géneros:", style: AppTextStyles.formTitle.copyWith(fontSize: 18)),
              Wrap(
                spacing: 8,
                children: widget.generos.map((g) => Chip(label: Text(g))).toList(),
              ),
              const SizedBox(height: 20),

              YoutubePlayerBuilder(
                player: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true),
                builder: (context, player) {
                  return player;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Abrir en YouTube'),
                style: AppButtonStyle.yellowButton,
                onPressed: _launchYoutube,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
