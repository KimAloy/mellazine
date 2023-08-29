import 'package:flutter/material.dart';

const Color myColor = Colors.green;
double titleSpacing = 6;

Widget buildShoppingSecurity({required BuildContext context}) {
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
    child: Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.verified_user_outlined, color: myColor, size: 18),
                SizedBox(width: 6),
                Text(
                  'Shopping security',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: myColor,
                  ),
                ),
                Spacer(),
                Icon(
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
    ),
  );
}

Widget sustainabilityAtMellazine({required BuildContext context}) {
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
    child: Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.energy_savings_leaf_outlined, color: myColor, size: 18),
            SizedBox(width: 6),
            Text(
              'Sustainability at Mellazine',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500, color: myColor),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _sustainabilityBottomSheet() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 100),
      child: Column(
        children: [
          _serviceTitle(
            title: 'Sustainability at Mellazine',
            icon: Icons.energy_savings_leaf_outlined,
          ),
          SizedBox(height: titleSpacing),
          _buildBottomSheetBulletPoint(
            text:
                "It's one planet we all share, it's abundant, it's big enough for all"
                " of us, but we must take the best care of it whole heartedly."
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

Widget _shoppingSecurityBottomSheet() {
  double mySpacing = 40;
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 100),
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
            text: "Delivery guaranteed\n\nAccurate and precise order tracking.",
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
            text: "Our customer service team is always here if you need help.",
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
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: myColor),
      )
    ],
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
