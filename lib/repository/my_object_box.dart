import 'package:mellazine/models/payment_card_model.dart';
import 'package:mellazine/models/user_address_model.dart';
import 'package:mellazine/objectbox.g.dart';

import '../models/mobile_money_phone_model.dart';
import '../models/shopping_cart_model.dart';

class MyObjectBox {
  late final Store _store;
  late final Box<ShoppingCartModel> _myShoppingCart;
  late final Box<AddAddressModel> _userAddress;
  late final Box<PaymentCardModel> _paymentCard;
  late final Box<MobileMoneyPhoneModel> _mobileMoneyPhone;

  MyObjectBox._init(this._store) {
    _myShoppingCart = Box<ShoppingCartModel>(_store);
    _userAddress = Box<AddAddressModel>(_store);
    _paymentCard = Box<PaymentCardModel>(_store);
    _mobileMoneyPhone = Box<MobileMoneyPhoneModel>(_store);
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
    item.isSelected = true;
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
    item.isSelected = !item.isSelected;
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

  /// paymentCard
  // READ
  PaymentCardModel? getPaymentCard(int id) => _paymentCard.get(id);

  // CREATE
  int createPaymentCard(PaymentCardModel user) => _paymentCard.put(user);

  // DELETE
  bool deletePaymentCard(int id) => _paymentCard.remove(id);

  // UPDATE
  updatePaymentCard({
    required PaymentCardModel newCardInfo,
    required int id,
  }) {
    // Get the object back from the box
    PaymentCardModel oldCardInfo = _paymentCard.get(id)!;
    // Update the object
    oldCardInfo.cardNumber = newCardInfo.cardNumber;
    oldCardInfo.expirationDate = newCardInfo.expirationDate;
    oldCardInfo.cvv = newCardInfo.cvv;
    oldCardInfo.cardHolder = newCardInfo.cardHolder;
    createPaymentCard(oldCardInfo);
  }

  // QUERY IF CARDS EXIST
  List<int> paymentCardsExist() {
    List<int> cardIds = [];
    List<PaymentCardModel> users = _paymentCard.query().build().find();
    for (var i in users) {
      cardIds.add(i.id);
    }
    // deleteUserAddress(2);
    // deleteUserAddress(3);
    // print('my_object_box.. cardIds: $cardIds');
    return cardIds;
  }

  /// mobile money payment
  // READ
 MobileMoneyPhoneModel? getMomoNumber(int id) => _mobileMoneyPhone.get(id);

  // CREATE
  int createMomoNumber(MobileMoneyPhoneModel user) => _mobileMoneyPhone.put(user);

  // DELETE
  bool deleteMomoNumber(int id) => _mobileMoneyPhone.remove(id);

  // UPDATE
  updateMomoNumber({
    required MobileMoneyPhoneModel newCardInfo,
    required int id,
  }) {
    // Get the object back from the box
    MobileMoneyPhoneModel oldCardInfo = _mobileMoneyPhone.get(id)!;
    // Update the object
    oldCardInfo.phoneNumber = newCardInfo.phoneNumber;
    createMomoNumber(oldCardInfo);
  }

  // QUERY IF CARDS EXIST
  List<int> momoExist() {
    List<int> cardIds = [];
    List<MobileMoneyPhoneModel> users = _mobileMoneyPhone.query().build().find();
    for (var i in users) {
      cardIds.add(i.id);
    }
    // deleteUserAddress(2);
    // deleteUserAddress(3);
    // print('my_object_box.. cardIds: $cardIds');
    return cardIds;
  }
}
