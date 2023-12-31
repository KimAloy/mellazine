import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mellazine/constants/constants.dart';
import 'package:mellazine/models/review_modal.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../models/shop_item_model.dart';
import '../repository/add_to_cart.dart';
import '../repository/number_formatter.dart';
import '../widgets/my_colored_container_divider.dart';
import '../widgets/quantity_button.dart';
import '../widgets/security_sustainability_widget.dart';

class ShopItemsDetailsPage extends StatefulWidget {
  const ShopItemsDetailsPage({Key? key, required this.item}) : super(key: key);
  final ShopItemModel item;

  @override
  State<ShopItemsDetailsPage> createState() => _ShopItemsDetailsPageState();
}

class _ShopItemsDetailsPageState extends State<ShopItemsDetailsPage> {
  int _quantityInput = 1;
  late LiquidController _liquidController;
  int currentIndex = 0;

  void newIndex(index) {
    setState(() {
      currentIndex = index;
      // print('item_for_sale: index is $index');
    });
  }

  void _swipeLeft() {
    final page = _liquidController.currentPage + 1;
    _liquidController.animateToPage(
      page: page > widget.item.images.length ? 0 : page,
      duration: 700,
    );
  }

  void _swipeRight() {
    final page = _liquidController.currentPage - 1;
    _liquidController.animateToPage(
      page: page > widget.item.images.length ? 0 : page,
      duration: 700,
    );
  }

  @override
  void initState() {
    _liquidController = LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: Key(widget.item.itemId),
        child: const Icon(Icons.add_shopping_cart_rounded),
        onPressed: () {
          // todo: implement
          // print('add to cart pressed');
          addToCart(
            item: widget.item,
            quantity: _quantityInput,
          ); // also displays toast
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLiquidSwipeImages(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.productName),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _price(item: widget.item),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildSoldItems(item: widget.item),
                          _buildStarRating(item: widget.item),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildQuantity(item: widget.item),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            buildShoppingSecurity(context: context),
            myColoredContainerDivider(color: Colors.white,height: 3),
            sustainabilityAtMellazine(context: context),
            _itemReviewsShopRatings(),
            const SizedBox(height: 140)
          ],
        ),
      ),
    );
  }

  Widget _itemReviewsShopRatings() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item reviews and shop ratings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 16, thickness: 0.5),
          _shopRatings(item: widget.item),
          const Divider(height: 16, thickness: 0.5),
          const Row(
            children: [
              Text(
                'Item reviews',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.grey,
              )
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(
                Icons.verified_outlined,
                color: Colors.green,
                size: 20,
              ),
              Text(' All reviews are from verified buyers.'),
            ],
          ),
          const SizedBox(height: 13),
          _reviewsList(),
        ],
      ),
    );
  }

  Widget _reviewsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: reviewsDummyList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        ReviewModel review = reviewsDummyList[index];
        return _buildReviewWidget(review: review);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 15);
      },
    );
  }

  Widget _buildReviewWidget({required ReviewModel review}) {
    String reviewerFirstName = review.reviewerFirstName.split(' ').first;
    List reviewerFirstNameLetters = reviewerFirstName.split('').toList();
    String firstInitial = reviewerFirstNameLetters.first;
    String lastInitial = reviewerFirstNameLetters.last;
    String date = DateFormat.yMMMd('en_US').format(review.createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle_outlined, color: Colors.grey),
            const SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$firstInitial***$lastInitial',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' on $date',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SmoothStarRating(
            starCount: 5,
            rating: review.rating,
            size: 15,
            color: Colors.black,
            borderColor: Colors.black,
            spacing: 0.0),
        Text(review.description),
      ],
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
      style: const TextStyle(color: Colors.black54),
    );
  }

  Widget _buildStarRating({required ShopItemModel item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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

  Widget _shopRatings({required ShopItemModel item}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          item.starRating.toString(),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        const SizedBox(width: 1),
        SmoothStarRating(
            starCount: 5,
            rating: item.starRating,
            size: 20,
            color: Colors.black,
            borderColor: Colors.black,
            spacing: 0.0),
        const SizedBox(width: 2),
        Text(
          '(${numFormat(num: item.totalRaters.toDouble())} shop ratings)',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _price({required ShopItemModel item}) {
    bool almostSoldOut = widget.item.inventory < kAlmostSoldOutQty;

    bool million = item.price > 999999;
    String price = numFormat(num: item.price);
    return Text(
      // todo: make currency '$' dynamic
      '\$${million ? '$price million' : price}',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: almostSoldOut ? Colors.deepOrange : Colors.black,
      ),
    );
  }

  Widget _buildImage({required String image}) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              // todo: replace with cachedNetworkImage
              image: AssetImage('assets/selling_now/$image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 10,
          child: _littleContainer(
            text: widget.item.images.length > 1
                ? '${currentIndex + 1} / ${widget.item.images.length}'
                : '1 / 1',
            color: Colors.black45,
          ),
        )
      ],
    );
  }

  Widget _littleContainer({
    required Color color,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuantity({required ShopItemModel item}) {
    return Row(
      children: [
        _quantityInputWidget(),
        const SizedBox(width: 10),
        _buildAlmostSoldOut(),
      ],
    );
  }

  Widget _quantityInputWidget() {
    // const buttonColor =  Theme.of(context).colorScheme.inversePrimary;
    return Row(
      children: [
        const Text(
          'Qty',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 10),
        changeQuantity(
            padding: 8,
            context: context,
            quantity: _quantityInput,
            reduce: () {
              // print('reduce');
              if (_quantityInput > 1) {
                setState(() => _quantityInput--);
              }
            },
            increase: () {
              // print('increment');

              setState(() => _quantityInput++);
            }),
      ],
    );
  }







  Widget _buildAlmostSoldOut() {
    bool almostSoldOut = widget.item.inventory < kAlmostSoldOutQty &&
        widget.item.inventory >= kOnlyLeftQty;
    bool onlyLeft = widget.item.inventory < kOnlyLeftQty;
    bool inPlenty = widget.item.inventory >= kAlmostSoldOutQty;

    return inPlenty
        ? const SizedBox.shrink()
        : Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    // Icons.hourglass_bottom_outlined,
                    CupertinoIcons.hourglass_bottomhalf_fill,
                    color: Colors.deepOrange,
                    size: 20,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(
                  text: almostSoldOut
                      ? 'Almost sold out'
                      : onlyLeft
                          ? 'Only ${widget.item.inventory} left'
                          : '',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildLiquidSwipeImages() {
    return GestureDetector(
      onPanUpdate: (details) {
        // Swiping from left to right direction.
        if (details.delta.dx > 0) {
          _swipeRight();
        }

        // Swiping from right to left direction.
        if (details.delta.dx < 0) {
          _swipeLeft();
        }
      },
      child: LiquidSwipe.builder(
        liquidController: _liquidController,
        initialPage: currentIndex,
        onPageChangeCallback: newIndex,
        itemCount: widget.item.images.length,
        itemBuilder: (context, index) {
          String image = widget.item.images[index];
          return _buildImage(image: image);
          // todo: use cachedNetworkImage
          //       child: Image.network(
          //         item,
          //         fit: BoxFit.cover,
          //         loadingBuilder: (BuildContext context, Widget child,
          //             ImageChunkEvent? loadingProgress) {
          //           if (loadingProgress == null) {
          //             return child;
          //           }
          //           return Center(
          //             child: CircularProgressIndicator(
          //               strokeWidth: kMyLoadingWidth,
          //               color: kMyLoadingColor,
          //               value: loadingProgress.expectedTotalBytes != null
          //                   ? loadingProgress.cumulativeBytesLoaded /
          //                       loadingProgress.expectedTotalBytes!
          //                   : null,
          //             ),
          //           );
          //         },
          //     );
        },
      ),
    );
  }
}
