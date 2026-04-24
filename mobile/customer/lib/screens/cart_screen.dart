import 'package:flutter/material.dart';
import 'package:shared/src/core/api_client.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {'name': 'Masroshi', 'price': 15.0, 'qty': 2},
    {'name': 'Bajiya', 'price': 10.0, 'qty': 3},
  ];

  double get _total => _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']));

  void _checkout() async {
    // Save to Hive offline cache first
    final pending = ApiClient().offlineBox.get('pending_orders', defaultValue: []);
    pending.add({
      'items': _cartItems,
      'total': _total,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'offline_queued'
    });
    await ApiClient().offlineBox.put('pending_orders', pending);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order saved! Syncing with network...')),
      );
      Navigator.pop(context);
    }
    
    // Attempt FastAPI sync immediately
    ApiClient().syncOfflineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vashi (Cart)')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Qty: \${item['qty']}'),
                  trailing: Text('MVR \${item['price'] * item['qty']}'),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('MVR \$_total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _checkout,
                      child: const Text('Checkout (POST /orders)'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
