import 'package:objectbox/objectbox.dart';

@Entity()
class ShoppingCartModel {
  int id; // objectBoxId
  int quantity;
  final String itemId;
  final String itemImage;
  final String sellerHashTag;
  final String productName;
  bool isSelected;

  ShoppingCartModel({
    this.id = 0,
    required this.isSelected,
    required this.quantity,
    required this.itemId,
    required this.itemImage,
    required this.productName,
    required this.sellerHashTag,
  });
}
