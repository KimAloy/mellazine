import 'package:flutter/material.dart';

import 'shop_items_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final accountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Mellazine'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 30, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Shop now directly"
                  "\nfrom your celebrity",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter celebrity's social media handle\nor enter product's short link",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GoogleTextField(
                  hintText: 'e.g. @MrBeast  or  @MrBeast/001',
                  controller: accountTextController,
                ),

                const SizedBox(height: 25),
                _shopNowButton(),
                const SizedBox(height: 45),
                _socialMediaIcons(),
                const SizedBox(height: 35),
                const Text(
                  '50+ payment methods available. Cards & Mobile money supported',
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                // todo: add long list of payment methods supported by country
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shopNowButton() {
    return FilledButton(
      onPressed: () {
        // print('search button pressed');
        // todo: implement
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ShopItemsPage(
            accountHandle: accountTextController.text,
          );
        }));
      },
      child: const Text('Shop now'),
    );
  }

  Widget _socialMediaIcons() {
    return Align(
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          _buildSocialMediaIcon(image: 'youtube_icon.png'),
          _buildSocialMediaIcon(image: 'tiktok_icon.png'),
          _buildSocialMediaIcon(image: 'instagram_icon.png'),
          _buildSocialMediaIcon(image: 'snapchat_icon.png'),
          _buildSocialMediaIcon(image: 'x_icon.png'),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon({required String image}) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$image'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class GoogleTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const GoogleTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          // borderSide: BorderSide(width: 0.8),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        isDense: true,
      ),
    );
  }
}
