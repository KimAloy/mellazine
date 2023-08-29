import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mellazine/models/shop_item_model.dart';
import 'package:mellazine/models/shopping_cart_model.dart';
import 'package:mellazine/repository/number_formatter.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../repository/my_snack_bar.dart';
import '../widgets/quantity_button.dart';
import '../pages/add_address_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  // Read items from objectbox local database
  late Stream<List<ShoppingCartModel>> _shoppingCartStream;

  @override
  void initState() {
    _shoppingCartStream = myObjectBox.getAllItemsStream().asBroadcastStream();
    super.initState();
  }

  final double _imageHeight = 100;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShoppingCartModel>>(
      stream: _shoppingCartStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          final cartList = snapshot.data!;
          int cartCount = 0;
          List<ShopItemModel> checkoutItemsList = [];
          List<ShoppingCartModel> availableInCartList = [];
          List<ShoppingCartModel> unavailableInCartList = [];
          List<ShopItemModel> fetchAvailableList = [];
          List<ShopItemModel> fetchUnavailableList = [];
          double checkoutTotalPrice = 0;
          // todo: delete and replace with one function from firestore using riverpod
          for (var shoppingCartItem in cartList) {
            // todo: replace with data form firestore
            ShopItemModel fetchItem = shopItemsList
                .firstWhere((i) => i.itemId == shoppingCartItem.itemId);
            // if item was deleted in firestore
            // todo: delete item from objectbox if item was deleted in firestore
            // if item is still available
            if (fetchItem.availability == true) {
              availableInCartList.add(shoppingCartItem);
              fetchAvailableList.add(fetchItem);
              // if user has deselected the item
              if (shoppingCartItem.deselected == false) {
                cartCount = cartCount + shoppingCartItem.quantity;
                // we put the checkout items in a list
                checkoutItemsList.add(fetchItem);
                // we calculate checkout items total price
                checkoutTotalPrice = checkoutTotalPrice +
                    (shoppingCartItem.quantity * fetchItem.price);
              }
            } else {
              unavailableInCartList.add(shoppingCartItem);
              fetchUnavailableList.add(fetchItem);
            }
          }
          String totalPrice = numFormat(
            num: double.parse(checkoutTotalPrice.toStringAsFixed(2)),
          );
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('Cart${cartCount == 0 ? '' : '($cartCount)'}'),
            ),
            floatingActionButton: _myFloatingActionButton(cartCount: cartCount),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _shoppingList(
                    availableInCartList: availableInCartList,
                    fetchAvailableList: fetchAvailableList,
                    unavailableInCartList: unavailableInCartList,
                    fetchUnavailableList: fetchUnavailableList,
                  ),
                  const SizedBox(height: 25),
                  _availabilityPriceWarning(),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Item(s) total:', style: _myTextStyle),
                        Text('\$$totalPrice', style: _myTextStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Taxes and delivery fees are calculated on the next page.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                          letterSpacing: 0),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _availabilityPriceWarning() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.black54,
                  size: 16,
                ),
              ),
              TextSpan(
                text: ' Item availability and prices is not guaranteed '
                    'until payment is final.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyCart() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.black26,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your shopping cart is empty',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Add your favorite items to shop'
                  ' directly from your celebrity!',
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _shoppingList({
    required List<ShoppingCartModel> availableInCartList,
    required List<ShopItemModel> fetchAvailableList,
    required List<ShoppingCartModel> unavailableInCartList,
    required List<ShopItemModel> fetchUnavailableList,
  }) {
    return availableInCartList.isEmpty && unavailableInCartList.isEmpty
        ? _emptyCart()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCartList(
                cartList: availableInCartList,
                fetchedFirestoreList: fetchAvailableList,
              ),
              unavailableInCartList.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          availableInCartList.isEmpty
                              ? const SizedBox.shrink()
                              : const Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Divider(height: 15, thickness: 0.5),
                                  ],
                                ),
                          Text(
                            'Unavailable items (${unavailableInCartList.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 10),
              _buildCartList(
                cartList: unavailableInCartList,
                fetchedFirestoreList: fetchUnavailableList,
              ),
            ],
          );
  }

  Widget _buildCartList({
    required List<ShoppingCartModel> cartList,
    required List<ShopItemModel> fetchedFirestoreList,
  }) {
    return ListView.separated(
      // padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartList.length,
      itemBuilder: (BuildContext context, int index) {
        ShoppingCartModel shoppingCartModel = cartList[index];
        ShopItemModel item = fetchedFirestoreList[index];
        int quantity = shoppingCartModel.quantity;
        int id = shoppingCartModel.id;
        bool deselected = shoppingCartModel.deselected;
        return _buildProduct(
          item: item,
          deselected: deselected,
          qty: quantity,
          objectBoxId: id,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
    );
  }

  Widget _buildProduct({
    required ShopItemModel item,
    required int qty,
    required int objectBoxId,
    required bool deselected,
  }) {
    return GestureDetector(
      onTap: () {
        // todo: navigate to details page
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // print('cool');
                if (item.availability == true) {
                  myObjectBox.deselect(objectBoxId);
                }
              },
              child: SizedBox(
                height: _imageHeight,
                child: Center(
                  child: item.availability == false
                      ? const Icon(Icons.check_circle, color: Colors.black12)
                      : deselected == true
                          ? const Icon(Icons.circle_outlined)
                          : const Icon(Icons.check_circle),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildImage(item: item),
            const SizedBox(width: 8),
            Expanded(
              child: _buildItemInfo(
                item: item,
                qty: qty,
                objectBoxId: objectBoxId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({required ShopItemModel item}) {
    return Container(
      height: _imageHeight,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          // todo: replace with cached network image
          image: AssetImage('assets/selling_now/${item.images[0]}'),
          fit: BoxFit.cover,
          // opacity value 1.0 is flutter's default
          opacity: item.availability == false ? 1.6 : 1.0,
        ),
      ),
    );
  }

  Widget _buildItemInfo({
    required ShopItemModel item,
    required int qty,
    required int objectBoxId,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.productName,
          overflow: TextOverflow.ellipsis,
        ),
        _soldBy(item: item),
        _buildAlmostSoldOut(item: item),
        const SizedBox(height: 2),
        _buildPriceQuantity(item: item),
        const SizedBox(height: 1),
        adjustQuantity(
          item: item,
          quantity: qty,
          objectBoxId: objectBoxId,
        ),
      ],
    );
  }

  Widget adjustQuantity({
    required ShopItemModel item,
    required int quantity,
    required int objectBoxId,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _changeQuantity(
          item: item,
          quantity: quantity,
          objectBoxId: objectBoxId,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          onPressed: () {
                            print('deselect');
                            myObjectBox.deselect(objectBoxId);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.deepOrange),
                          child: Text(
                            item.availability == true
                                ? 'Deselect and keep in cart'
                                : 'Keep in cart',
                          ),
                        ),
                        const SizedBox(height: 5),
                        OutlinedButton(
                          onPressed: () {
                            myObjectBox.deleteItem(objectBoxId);
                            Navigator.of(context, rootNavigator: true).pop();
                            // print('remove alert dialog');
                          },
                          child: const Text('Remove'),
                        ),
                      ],
                    ),
                  ],
                  content: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 5),
                      item.availability == false
                          ? RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'You can keep this item in your'
                                          ' cart and buy it when your'),
                                  TextSpan(
                                      text: ' celebrity ',
                                      style:
                                          TextStyle(color: Colors.deepOrange)),
                                  TextSpan(text: 'makes it available.')
                                ],
                              ),
                            )
                          : RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          'You can keep this item in your cart'
                                          ' by deselecting it to'),
                                  TextSpan(
                                    text: ' enjoy ',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                  TextSpan(text: 'buying it from your'),
                                  TextSpan(
                                    text: ' celebrity ',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                  TextSpan(text: 'later.'),
                                ],
                              ),
                            ),
                      const SizedBox(height: 10),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          // todo: replace with cached network image
                          image: AssetImage(
                              'assets/selling_now/${item.images[0]}'),
                          fit: BoxFit.cover,
                        )),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Icon(
              CupertinoIcons.delete,
              color: Colors.black38,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceQuantity({required ShopItemModel item}) {
    bool sellingOut = item.inventory < kAlmostSoldOutQty;
    return Text(
      '\$${numFormat(num: item.price)}',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: sellingOut ? Colors.deepOrange : Colors.black,
      ),
    );
  }

  Widget _soldBy({required ShopItemModel item}) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 12),
        children: [
          const TextSpan(text: 'By '),
          TextSpan(
            text: item.sellerHashTag,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlmostSoldOut({required ShopItemModel item}) {
    bool almostSoldOut =
        item.inventory < kAlmostSoldOutQty && item.inventory >= kOnlyLeftQty;
    bool onlyLeft = item.inventory < kOnlyLeftQty;
    bool inPlenty = item.inventory >= kAlmostSoldOutQty;

    return inPlenty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    // Icons.hourglass_bottom_outlined,
                    CupertinoIcons.hourglass_bottomhalf_fill,
                    color: Colors.deepOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    almostSoldOut
                        ? 'Almost sold out'
                        : onlyLeft
                            ? 'Only ${item.inventory} left'
                            : '',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      overflow: TextOverflow.ellipsis,fontSize: 13
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _changeQuantity({
    required ShopItemModel item,
    required int quantity,
    required int objectBoxId,
  }) {
    double padding = 6;
    double iconSize = 16;
    return changeQuantity(
        padding: padding,
        context: context,
        iconSize: iconSize,
        quantity: quantity,
        objectBoxId: objectBoxId,
        reduce: () {
          // print('reduce');
          if (item.availability == true) {
            if (quantity == 1) {
              print('low quantity');
            } else {
              myObjectBox.reduce(objectBoxId);
            }
          }
        },
        increase: () {
          // print('increment');
          if (item.availability == true) {
            myObjectBox.increment(id: objectBoxId, quantity: 1);
          }
        });
  }

  Widget _myFloatingActionButton({required int cartCount}) {
    return SizedBox(
      width: 130,
      height: 40,
      child: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        key: const Key('checkout'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.white,
              size: 18,
            ),
            Text(
              ' Checkout ${cartCount == 0 ? '' : '($cartCount) '}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          // print('checkout cart pressed');
          if (cartCount > 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const AddAddressPage();
            }));
          } else {
            mySnackBar(context: context, message: 'Cart is empty');
          }
        },
      ),
    );
  }

  final TextStyle _myTextStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}
