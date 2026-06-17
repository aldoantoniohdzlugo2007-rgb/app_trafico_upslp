import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tráfico UPSLP',
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Lista de cajones piloto calibrados exactamente para el estacionamiento de la UPSLP
  final List<Map<String, dynamic>> cajonesPiloto = [
    {
      'id': 'Cajón A-01',
      'zona': 'Estacionamiento Principal',
      'disponible': true,
      'coordenadas': const LatLng(22.11952, -100.93175),
      'ultimaActualizacion': 'Hace 2 min',
    },
    {
      'id': 'Cajón A-02',
      'zona': 'Estacionamiento Principal',
      'disponible': false,
      'coordenadas': const LatLng(22.11948, -100.93168),
      'ultimaActualizacion': 'Hace 5 min',
    },
    {
      'id': 'Cajón B-01',
      'zona': 'Estacionamiento de Alumnos',
      'disponible': true,
      'coordenadas': const LatLng(22.11944, -100.93161),
      'ultimaActualizacion': 'Justo ahora',
    },
    {
      'id': 'Cajón B-02',
      'zona': 'Estacionamiento de Alumnos',
      'disponible': false,
      'coordenadas': const LatLng(22.11940, -100.93154),
      'ultimaActualizacion': 'Hace 15 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Estacionamiento UPSLP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(22.1192, -100.9314),
          initialZoom: 16.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.upslp.app_trafico_upslp',
          ),
          MarkerLayer(
            markers: cajonesPiloto.map((cajon) {
              return Marker(
                point: cajon['coordenadas'],
                width: 45,
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${cajon['id']} | ${cajon['zona']}\nEstado: ${cajon['disponible'] ? "Disponible" : "Ocupado"} (${cajon['ultimaActualizacion']})',
                        ),
                        backgroundColor: const Color(0xFF0F172A),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: cajon['disponible'] 
                          ? Colors.green.withOpacity(0.85) 
                          : Colors.red.withOpacity(0.85),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Icon(Icons.local_parking, color: Colors.white, size: 22),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}