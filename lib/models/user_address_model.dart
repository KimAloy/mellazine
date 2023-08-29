
import 'package:objectbox/objectbox.dart';


@Entity()
class AddAddressModel {
  int id;
   String country;
   String fullName;
   String streetAddress;
   String apartmentEtc;
   String zipCode;
   String city;
   String state;
   String phoneNumber;

  AddAddressModel({
    this.id =0,
    required this.country,
    required this.fullName,
    required this.streetAddress,
    required this.apartmentEtc,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.phoneNumber,
  });
}
