import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
import "package:daftar_belanja/services/shopping_service.dart";

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final ShoppingService _shoppingService = ShoppingService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Belanja',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama barang',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        _shoppingService.addShoppingItem(name);
                        _nameController.clear();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                  stream: _shoppingService.getShoppingList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final data = snapshot.data?.snapshot.value;

                    if (data == null) {
                      return const Center(child: Text('Belum ada item.'));
                    }

                    final Map<dynamic, dynamic> itemsMap =
                        data as Map<dynamic, dynamic>;
                    final items = itemsMap.entries.toList();

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final key = items[index].key as String;
                        final item = Map<String, dynamic>.from(
                          items[index].value as Map,
                        );
                        final String name = item['name'] ?? '';

                        return ListTile(
                          title: Text(name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _shoppingService.removeShoppingItem(key);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}