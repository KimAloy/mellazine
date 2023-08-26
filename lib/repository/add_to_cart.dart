import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/shop_item_model.dart';
import '../models/shopping_cart_model.dart';

void addToCart({
  required ShopItemModel item,
  required int quantity,
}) {
  List<ShoppingCartModel> existingItems = myObjectBox.itemExits(item.itemId);
  final bool exists = existingItems.isEmpty;
  if (exists == true) {
    // if it doesn't exist Create It
    ShoppingCartModel create = ShoppingCartModel(
      quantity: quantity,
      itemId: item.itemId,
      deselected: true,
    );
    myObjectBox.insertItem(create);
    // print('shop_items_page: created to my objectbox');
    _myToast(text: 'Added to cart');
  } else {
    ShoppingCartModel firstItem = existingItems.first;
    myObjectBox.increment(
      id: firstItem.id,
      quantity: quantity,
    ); // add to quantity
    // print('shop_items_page: added more items to objectbox');
    _myToast(text: 'Added more to cart');
  }
}

_myToast({required String text}) {
  Fluttertoast.showToast(
    msg: text,
    fontSize: 16,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
  );
}
