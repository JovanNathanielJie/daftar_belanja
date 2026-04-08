import "package:firebase_database/firebase_database.dart";

class ShoppingService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'shopping_list',
  );

  Stream<DatabaseEvent> getShoppingList() {
    return _database.onValue;
  }

  Future<void> addShoppingItem(String name) async {
    await _database.push().set({
      'name': name,
    });
  }

  Future<void> removeShoppingItem(String key) async {
    await _database.child(key).remove();
  }
}