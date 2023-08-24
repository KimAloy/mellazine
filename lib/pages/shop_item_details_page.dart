import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mellazine/constants/constants.dart';
import 'package:mellazine/models/review_modal.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../models/shop_item_model.dart';
import '../repository/number_formatter.dart';

class ShopItemsDetailsPage extends StatefulWidget {
  const ShopItemsDetailsPage({Key? key, required this.item}) : super(key: key);
  final ShopItemModel item;

  @override
  State<ShopItemsDetailsPage> createState() => _ShopItemsDetailsPageState();
}

class _ShopItemsDetailsPageState extends State<ShopItemsDetailsPage> {
  final Color myColor = Colors.green;
  double titleSpacing = 6;
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
          print('add to cart pressed');
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _myCustomDivider(),
            _buildShoppingSecurity(),
            _myCustomDivider(),
            _sustainabilityAtMellazine(),
            _myCustomDivider(),
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
    bool million = item.price > 999999;
    String price = numFormat(num: item.price);
    return Text(
      // todo: make currency '$' dynamic
      '\$${million ? '$price million' : price}',
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange),
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
        _quantityButton(
          onPressed: () {
            print('reduce');
            setState(() => _quantityInput--);
          },
          symbol: Icons.remove,
        ),
        const SizedBox(width: 10),
        Text(
          _quantityInput.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        _quantityButton(
          onPressed: () {
            print('increment');
            setState(() => _quantityInput++);
          },
          symbol: Icons.add,
        ),
      ],
    );
  }

  Widget _quantityButton({
    required Function()? onPressed,
    required IconData symbol,
  }) {
    final myColorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: myColorTheme.inversePrimary.withOpacity(0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Icon(
                symbol,
                color: myColorTheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShoppingSecurity() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          constraints: BoxConstraints.loose(
            Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.8,
            ),
          ),
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return _shoppingSecurityBottomSheet();
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined, color: myColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Shopping security',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: myColor),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.grey,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint(text: 'Safe payment options'),
                      _buildBulletPoint(text: 'Secure logistics'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint(text: 'Secure privacy'),
                      _buildBulletPoint(text: 'Purchase protection'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sustainabilityAtMellazine() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          constraints: BoxConstraints.loose(
            Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.8,
            ),
          ),
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return _sustainabilityBottomSheet();
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.energy_savings_leaf_outlined, color: myColor, size: 18),
            const SizedBox(width: 6),
            Text(
              'Sustainability at Mellazine',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500, color: myColor),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sustainabilityBottomSheet() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 100),
        child: Column(
          children: [
            _serviceTitle(
              title: 'Sustainability at Mellazine',
              icon: Icons.energy_savings_leaf_outlined,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text:
                  "It's one planet that we all abundantly share, it's big enough for all"
                  " of us, but we must take care of it whole heartedly."
                  "\n\nMellazine"
                  " has planted over 35,000 trees in Africa. We've been able to "
                  "witness the transformative power of trees on the land and local "
                  "communities, while also addressing global environmental concerns.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _myCustomDivider() {
    return Container(
      height: 5,
      width: double.infinity,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildBulletPoint({required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 6, color: Colors.black54),
        const SizedBox(width: 4),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.5, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetBulletPoint({required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 7),
          child: Icon(Icons.circle, size: 7),
        ),
        const SizedBox(width: 4),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _shoppingSecurityBottomSheet() {
    double mySpacing = 40;
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _serviceTitle(
              title: 'Safe Payment Methods',
              icon: Icons.verified_user_outlined,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text: "Your payment information is safe with us."
                  " Mellazine does not share your "
                  "information with the anyone.",
            ),
            Divider(height: mySpacing),
            _serviceTitle(
              title: 'Secure logistics',
              icon: Icons.local_shipping_outlined,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text:
                  "Package safety\n\nFull refund for your damaged or lost package.",
            ),
            Divider(height: mySpacing),
            _serviceTitle(
              title: 'Secure privacy',
              icon: Icons.lock_outline_rounded,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text:
                  "Delivery guaranteed\n\nAccurate and precise order tracking.",
            ),
            Divider(height: mySpacing),
            _serviceTitle(
              title: 'Purchase protection',
              icon: Icons.thumb_up,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text:
                  "Shop confidently on Mellazine knowing that if something goes wrong, we've always got your back.",
            ),
            Divider(height: mySpacing),
            _serviceTitle(
              title: 'Customer service',
              icon: Icons.headset_mic_rounded,
            ),
            SizedBox(height: titleSpacing),
            _buildBottomSheetBulletPoint(
              text:
                  "Our customer service team is always here if you need help.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTitle({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: myColor),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: myColor),
        )
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
