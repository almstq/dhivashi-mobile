import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTourismMode = false;

  final List<Marker> _shopMarkers = [
    Marker(
      point: const LatLng(4.1755, 73.5093),
      width: 40,
      height: 40,
      child: const Icon(Icons.store, color: Colors.blue, size: 40),
    ),
    Marker(
      point: const LatLng(4.1760, 73.5100),
      width: 40,
      height: 40,
      child: const Icon(Icons.store, color: Colors.blue, size: 40),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isTourismMode ? 'Explore Shops' : 'Fihhaara Explore'),
        actions: [
          Row(
            children: [
              const Icon(Icons.flight_takeoff, size: 16),
              Switch(
                value: _isTourismMode,
                onChanged: (val) {
                  setState(() => _isTourismMode = val);
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(4.1755, 73.5093), // Male' Atoll
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dhivashi.customer',
              ),
              MarkerLayer(markers: _shopMarkers),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _isTourismMode ? 'Search products...' : 'Mudhaa hoadhumaah...',
                    border: InputBorder.none,
                    icon: const Icon(Icons.search),
                  ),
                  onSubmitted: (query) {
                    // Trigger pgvector search via FastAPI
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        },
        label: Text(_isTourismMode ? 'Cart' : 'Vashi'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
