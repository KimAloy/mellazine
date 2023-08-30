import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/shop_item_model.dart';
import '../models/shopping_cart_model.dart';

Future<void> addToCart({
  required ShopItemModel item,
  required int quantity,
}) async {
  // todo: before hosting, replace with first image_url from firebase storage
  // convert (encode) image to base64
  ByteData bytes =
      await rootBundle.load('assets/selling_now/${item.images[0]}');
  var buffer = bytes.buffer;
  var myBase64Image = base64.encode(Uint8List.view(buffer));

  List<ShoppingCartModel> existingItems = myObjectBox.itemExits(item.itemId);
  if (existingItems.isEmpty) {
    // if it doesn't exist Create It
    ShoppingCartModel create = ShoppingCartModel(
      quantity: quantity,
      itemId: item.itemId,
      isSelected: true,
      sellerHashTag: item.sellerHashTag,
      productName: item.productName,
      itemImage: myBase64Image,
    );
    myObjectBox.insertItem(create);
    // print('shop_items_page: created to my objectbox');
    _myToast(text: 'Added to cart');
  } else {
    ShoppingCartModel firstItem = existingItems.first;
    // update
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
