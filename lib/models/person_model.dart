
class PersonModel {
  final String id;
  final String token;
  final String role; // user, admin
  final String name;
  final String phone;
  final String email;
  final String profilePicture;
  final double accountBalance;
  final int totalTrips;
  final double starRanking;
  final bool instantBook;
  final DateTime createdAt;

  PersonModel({
    required this.id,
    required this.token,
    required this.role,
    required this.email,
    required this.name,
    required this.phone,
    required this.profilePicture,
    required this.accountBalance,
    required this.totalTrips,
    required this.starRanking,
    required this.instantBook,
    required this.createdAt,
  });
}

final PersonModel kimbowaCurrentDriver = PersonModel(
  createdAt:DateTime.now(),
  name: 'Kimbowa Israel',
  phone: '+256789456147',
  id: 'ciik',
  token: 'khsfkjsf;jk',
  role: 'user', // fan or celebrity // todo: implement
  email: 'kimbowaisrael@gmail.com',
  profilePicture: 'assets/wakanda_forever.jpeg',
  accountBalance: 250000,
  totalTrips: 5,
  starRanking: 4.5,
  instantBook: false,
);

