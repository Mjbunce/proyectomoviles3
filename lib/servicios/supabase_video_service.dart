import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client; // Instancia global

Future<String?> obtenerUrlFirmada(
  String nombreArchivo, {
  String bucket = 'videos',
  int duracionSegundos = 3600,
}) async {
  try {
    final url = await supabase.storage
        .from(bucket)
        .createSignedUrl(nombreArchivo, duracionSegundos);
    return url;
  } catch (e) {
    print('Error al generar URL firmada: $e');
    return null;
  }
}
