import 'package:objectbox/objectbox.dart';

@Entity()
class ShoppingCartModel {
  int id; // objectBoxId
  int quantity;
  final String itemId;
  bool deselected;

  ShoppingCartModel({
    this.id = 0,
    required this.deselected,
    required this.quantity,
    required this.itemId,
  });
}
