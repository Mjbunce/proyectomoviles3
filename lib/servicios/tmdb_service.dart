import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  final String apiKey = '30c54da473ded1735c0a691c2778a035'; 
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Obtener películas populares
  Future<List<dynamic>> getPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=es-ES&page=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al obtener las películas populares');
    }
  }

  // Obtener películas por género
  Future<List<dynamic>> getMoviesByGenre(int genreId) async {
    final url = Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&language=es-ES&page=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al obtener películas por género');
    }
  }
  Future<String?> getTrailerYoutubeUrl(int movieId) async {
  final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=es-ES');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'] as List<dynamic>;

    // Buscamos el trailer oficial en YouTube
    final trailer = results.firstWhere(
      (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
      orElse: () => null,
    );

    if (trailer != null) {
      final key = trailer['key'];
      return 'https://www.youtube.com/watch?v=$key';
    } else {
      return null; // No trailer encontrado
    }
  } else {
    throw Exception('Error al obtener trailers');
  }
}

}
