class ShopItemModel {
  final String itemId;
  final String sellerId;
  final String sellerHashTag;
  final List images;
  final String productName;
  final double price;
  final int sold;
  final double starRating;
  final int totalRaters;
  final int inventory;
  final bool availability;
  double? oldPrice; // this is displayed as a crossed / strike-through figure
  Map? colors; // {'red':'imageURL'}
  Map? sizes; // {'XL':"Ush 250"}
  String? dimensions;
  String? weight;
  String? brand;
  String? returnPolicy;
  String? warranty;
  String? customerSupport;
  String? category;
  List? tags;
  double? taxes;
  Map? discounts; // {200 items: 10% discount}
  Map? promoCode; // {'12fd':'15% off'}
  Map? shipping;

  ShopItemModel({
    double? oldPrice, // this is displayed as a crossed / strike-through figure
    this.colors, // {'red':'imageURL'}
    this.sizes, // {'XL':"Ush 250"}
    this.dimensions,
    this.weight,
    this.brand,
    this.returnPolicy,
    this.warranty,
    this.customerSupport,
    this.category,
    this.tags,
    this.taxes,
    this.discounts, // {200 items: 10% discount}
    this.promoCode, // {'12fd':'15% off'}
    this.shipping,
    required this.itemId,
    required this.availability,
    required this.sellerId,
    required this.images,
    required this.productName,
    required this.price,
    required this.sold,
    required this.sellerHashTag,
    required this.starRating,
    required this.totalRaters,
    required this.inventory,
  });
}

final List<ShopItemModel> shopItemsList = [
  ShopItemModel(
    sellerId: 'kjafih',
    sellerHashTag: '@queenHund',
    itemId: 'coo',
    availability: true,
    images: [
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    productName:
        'Smart Watch For Women Men (Answer/Make Call Via BT), Large Full Touch Display Screen SmartWatch, Fitness Tracker Watch With 10+ Sports Modes Heart Rate, Blood Oxygen, Sleep Monitor, For Android IOS',
    price: 7.64,
    sold: 42000,
    starRating: 4.5,
    totalRaters: 1219,
    inventory: 25,
  ),
  ShopItemModel(
    sellerHashTag: '@queenHund',
    availability: false,
    itemId: 'col',
    images: [
      'diamond_1.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    sellerId: 'kjafih',
    productName: 'Diamond Platinum ring',
    price: 650,
    sold: 100,
    starRating: 4.5,
    totalRaters: 50,
    inventory: 15,
  ),
  ShopItemModel(
    availability: true,
    itemId: 'ool',
    sellerId: 'kjafih',
    images: [
      'wakanda_forever.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    sellerHashTag: '@queenHund',
    productName:
        'Wakanda necklace. The perfect necklace for the man of your style',
    price: 1000000,
    sold: 1000,
    starRating: 4.2,
    totalRaters: 800,
    inventory: 1000,
  ),
  ShopItemModel(
    itemId: 'ol',
    sellerId: 'kjafih',
    images: [
      'necklace_1.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    productName: 'Queen necklace for the lovers heaven. Best is best',
    price: 10000,
    sold: 15,
    availability: true,
    starRating: 5,
    sellerHashTag: '@queenHund',
    totalRaters: 1200,
    inventory: 25,
  ),
  ShopItemModel(
    sellerHashTag: '@queenHund',
    itemId: 'l',
    images: [
      'necklace_2.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    sellerId: 'kjafih',
    productName: "Angel's love",
    availability: true,
    price: 350000,
    sold: 3250,
    starRating: 4.4,
    totalRaters: 13,
    inventory: 49,
  ),
  ShopItemModel(
    itemId: 'cl',
    sellerId: 'kjafih',
    images: [
      'watch_1.png',
      'ring_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    availability: true,
    sellerHashTag: '@queenHund',
    productName: 'Obasanjo Gold ring',
    price: 7860000,
    sold: 698,
    starRating: 4.8,
    totalRaters: 382,
    inventory: 19,
  ),
  ShopItemModel(
    itemId: 'cdool',
    sellerId: 'kjafih',
    images: [
      'ring_2.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    productName: 'Lovely Dustin ring',
    availability: true,
    price: 400000,
    sold: 100,
    starRating: 4.7,
    totalRaters: 18,
    sellerHashTag: '@queenHund',
    inventory: 0,
  ),
  ShopItemModel(
    itemId: 'coerol',
    sellerHashTag: '@queenHund',
    availability: false,
    images: [
      'niel.png',
      'watch_1.png',
      'watch_2.png',
      'watch_3.png',
      'watch_4.png',
      'watch_5.png',
      'watch_6.png',
    ],
    sellerId: 'kjafih',
    productName: 'Lovely Niel Lance and Loree Rowland perfect necklace',
    price: 1050000,
    sold: 42150,
    starRating: 4.8,
    totalRaters: 22,
    inventory: 68,
  ),
];
