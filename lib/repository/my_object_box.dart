import 'package:mellazine/models/user_address_model.dart';
import 'package:mellazine/objectbox.g.dart';

import '../models/shopping_cart_model.dart';

class MyObjectBox {
  late final Store _store;
  late final Box<ShoppingCartModel> _myShoppingCart;
  late final Box<AddAddressModel> _userAddress;

  MyObjectBox._init(this._store) {
    _myShoppingCart = Box<ShoppingCartModel>(_store);
    _userAddress = Box<AddAddressModel>(_store);
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
    // Update the object
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

  /// userAddress
  // READ
  AddAddressModel? getUserAddress(int id) => _userAddress.get(id);

  // CREATE
  int createUser(AddAddressModel user) => _userAddress.put(user);

  // DELETE
  bool deleteUserAddress(int id) => _userAddress.remove(id);

  // UPDATE
  updateUserAddress({
    required AddAddressModel newUserAddress,
    required int id,
  }) {
    // Get the object back from the box
    AddAddressModel oldUserAddress = _userAddress.get(id)!;
    // Update the object
    oldUserAddress.country = newUserAddress.country;
    oldUserAddress.fullName = newUserAddress.fullName;
    oldUserAddress.streetAddress = newUserAddress.streetAddress;
    oldUserAddress.apartmentEtc = newUserAddress.apartmentEtc;
    oldUserAddress.zipCode = newUserAddress.zipCode;
    oldUserAddress.city = newUserAddress.city;
    oldUserAddress.state = newUserAddress.state;
    oldUserAddress.phoneNumber = newUserAddress.phoneNumber;
    createUser(oldUserAddress);
  }

  // QUERY IF A USER EXISTS
  List<int> usersExist() {
    List<int> userIds = [];
    List<AddAddressModel> users = _userAddress.query().build().find();
    for (var i in users) {
      userIds.add(i.id);
    }
    // deleteUserAddress(2);
    // deleteUserAddress(3);
    // print('my_object_box.. userIds: $userIds');
    return userIds;
  }
}
