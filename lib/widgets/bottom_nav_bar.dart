import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../main.dart';
import '../models/shop_item_model.dart';
import '../models/shopping_cart_model.dart';
import '../pages/MyMellazinePage.dart';
import '../pages/shopping_cart_page.dart';
import '../pages/homepage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const ShoppingCartPage(),
      const MyMellazinePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems({
    required BuildContext context,
  }) {
    const Color inactiveColorPrimary = Colors.black54;
    final Color activeColor = Theme.of(context).colorScheme.primary;
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: StreamBuilder<List<ShoppingCartModel>>(
          stream: _shoppingCartStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              final cartList = snapshot.data!;
              int cartCount = 0;
              for (var shoppingCartItem in cartList) {
                // todo: replace with data form firestore. Copy full code form shopping_cart_page
                ShopItemModel fetchItem = shopItemsList
                    .firstWhere((i) => i.itemId == shoppingCartItem.itemId);
                // if item is still available
                if (fetchItem.availability == true &&
                    shoppingCartItem.deselected == false) {
                  cartCount = cartCount + shoppingCartItem.quantity;
                }
              }

              return cartCount == 0
                  ? const Icon(Icons.shopping_cart_outlined)
                  : Badge(
                      backgroundColor: Colors.deepOrange,
                      label: Text('$cartCount'),
                      child: const Icon(Icons.shopping_cart_outlined),
                    );
            }
          },
        ),
        title: ('Cart'),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        // todo: implement using unread messages from firestore
        icon: Badge(
          backgroundColor: Colors.deepOrange,
          label: Text('2'), // todo: impelement
          child: const Icon(Icons.account_circle_outlined),
        ),
        title: ("My Mellazine"),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColorPrimary,
      ),
    ];
  }

  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    _shoppingCartStream = myObjectBox.getAllItemsStream().asBroadcastStream();
    super.initState();
  }

  late Stream<List<ShoppingCartModel>> _shoppingCartStream;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(context: context),
      confineInSafeArea: true,
      backgroundColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),

      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
