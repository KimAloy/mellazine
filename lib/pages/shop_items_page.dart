import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../models/shop_item_model.dart';
import '../models/shopping_cart_model.dart';
import '../repository/add_to_cart.dart';
import '../repository/my_snack_bar.dart';
import '../repository/number_formatter.dart';
import 'shop_item_details_page.dart';

class ShopItemsPage extends StatefulWidget {
  const ShopItemsPage({
    Key? key,
    required this.accountHandle,
  }) : super(key: key);
  final String accountHandle;

  @override
  State<ShopItemsPage> createState() => _ShopItemsPageState();
}

class _ShopItemsPageState extends State<ShopItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Mellazine ${widget.accountHandle}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 5, color: Colors.grey.shade200),
            _buildGridView()
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            mainAxisExtent: 268.5,
            crossAxisSpacing: 3.5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shopItemsList.length,
          itemBuilder: (context, index) {
            ShopItemModel item = shopItemsList[index];
            return _buildItemWidget(
              item: item,
              context: context,
            );
          }),
    );
  }

  Widget _buildItemWidget({
    required ShopItemModel item,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        if (item.inventory == 0) {
          mySnackBar(
            context: context,
            message: 'This product has been sold out.',
          );
        } else if (item.availability == false) {
          mySnackBar(
            context: context,
            message: 'This product is not available right now.',
          );
        } else {
          // print('navigate to next page ${item.productName}');
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ShopItemsDetailsPage(item: item);
          }));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _itemImage(item: item),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                _buildStarRating(item: item),
                _buildAnimatedText(item: item),
                _buildPriceSoldCart(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoldItems({required ShopItemModel item}) {
    bool sold = item.sold > 999;
    String highlySold = (item.sold / 1000).toStringAsFixed(1);
    if (highlySold.endsWith('0')) {
      highlySold = (item.sold / 1000).toStringAsFixed(0);
    }
    return Text(
      '${sold ? '${highlySold}K+' : item.sold} sold',
      style: const TextStyle(fontSize: 12, color: Colors.black54),
    );
  }

  Widget _price({required ShopItemModel item}) {
    bool price = item.price > 99999;
    String highlyPriced = (item.price / 1000).toStringAsFixed(2);
    bool million = item.price > 999999;
    if (item.price > 999999) {
      highlyPriced = (item.price / 1000000).toStringAsFixed(2);
    }
    // if (highlyPriced.endsWith('0')&& million) {
    //   highlyPriced = (item.price / 1000000).toStringAsFixed(0);
    // }
    highlyPriced = numFormat(num: double.parse(highlyPriced));
    return Text(
      // todo: make currency '$' dynamic
      '\$${million ? '${highlyPriced}m' : price ? '${highlyPriced}K' : numFormat(num: item.price)}',
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  Widget _itemImage({required ShopItemModel item}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: double.infinity,
        height: 175,
        decoration: BoxDecoration(
          image: DecorationImage(
            // todo: replace with cachedNetworkImage
            image: AssetImage('assets/selling_now/${item.images[0]}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating({required ShopItemModel item}) {
    return Row(
      children: [
        SmoothStarRating(
            starCount: 5,
            rating: item.starRating,
            size: 15,
            color: Colors.black,
            borderColor: Colors.black,
            spacing: 0.0),
        const SizedBox(width: 2),
        Text(
          '(${numFormat(num: item.totalRaters.toDouble())})',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAnimatedText({required ShopItemModel item}) {
    const String justAddedToCart = 'just added to cart';
    return item.availability == false
        ? _infoWidget(text: 'Not available right now')
        : item.inventory == 0
            ? _infoWidget(text: 'Sold out')
            : SizedBox(
                height: 13.5,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(seconds: 3),
                    animatedTexts: [
                      FadeAnimatedText(justAddedToCart),
                      item.inventory < kAlmostSoldOutQty
                          ? FadeAnimatedText(
                              kAlmostSoldOutString,
                              textStyle:
                                  const TextStyle(color: Colors.deepOrange),
                            )
                          : FadeAnimatedText(justAddedToCart),
                      item.inventory < kOnlyLeftQty
                          ? FadeAnimatedText(
                              kOnlyLeftString(inventory: item.inventory),
                              textStyle:
                                  const TextStyle(color: Colors.deepOrange),
                            )
                          : FadeAnimatedText(justAddedToCart),
                    ],
                  ),
                ),
              );
  }

  Widget _buildPriceSoldCart({required ShopItemModel item}) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: _price(item: item),
                ),
                const SizedBox(width: 2.5),
                _buildSoldItems(item: item),
              ],
            ),
          ),
          item.inventory == 0 // item is sold out
                  ||
                  item.availability == false
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // print('add to shopping cart tapped');

                        addToCart(
                          item: item,
                          quantity: 1,
                        ); // displays toast when successful
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Icon(
                            Icons.add_shopping_cart_outlined,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _infoWidget({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 12.5,
      ),
    );
  }
}
