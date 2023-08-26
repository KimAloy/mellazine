import 'package:mellazine/objectbox.g.dart';

import '../models/shopping_cart_model.dart';

class MyObjectBox {
  late final Store _store;
  late final Box<ShoppingCartModel> _myShoppingCart;

  MyObjectBox._init(this._store) {
    _myShoppingCart = Box<ShoppingCartModel>(_store);
  }

  static Future<MyObjectBox> init() async {
    final store = await openStore();
    return MyObjectBox._init(store);
  }

  /// myShoppingCart
  // READ
  ShoppingCartModel? getItems(int id) => _myShoppingCart.get(id);

  // CREATE
  int insertItem(ShoppingCartModel item) => _myShoppingCart.put(item);

  // DELETE
  bool deleteItem(int id) => _myShoppingCart.remove(id);

  // UPDATE
  increment({required int id, required int quantity}) {
    // Get the object back from the box
    ShoppingCartModel item = _myShoppingCart.get(id)!;
    // // Update the object
    item.quantity = item.quantity + quantity;
    insertItem(item);
  }

  reduce(int id) {
    // Get the object back from the box
    ShoppingCartModel item = _myShoppingCart.get(id)!;
    // Update the object
    item.quantity = item.quantity - 1;
    insertItem(item);
  }

  deselect(int id) {
    // Get the object back from the box
    ShoppingCartModel item = _myShoppingCart.get(id)!;
    // Update the object
    item.deselected = !item.deselected;
    // print('my_object_box: ${item.deselected}');
    insertItem(item);
  }

  // READ ALL Items STREAM
  Stream<List<ShoppingCartModel>> getAllItemsStream() {
    // triggerImmediately gets the data without waiting for the update
    return _myShoppingCart
        .query()
        .order(ShoppingCartModel_.id, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

// QUERY SPECIFIC item
  List<ShoppingCartModel> itemExits(itemId) {
    Query<ShoppingCartModel> exists =
        _myShoppingCart.query(ShoppingCartModel_.itemId.equals(itemId)).build();
    return exists.find();
  }
}
