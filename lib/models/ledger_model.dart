import '../constants/constants.dart';

class LedgerModel {
  final String id; // entry id
  final String trip;
  final String type; // income, withdraw
  final int passengers;
  final int tripAmount;
  final DateTime date;

  LedgerModel({
    required this.passengers,
    required this.id,
    required this.type,
    required this.tripAmount,
    required this.date,
    required this.trip,
  });
}

final List<LedgerModel> accountLedgerList = [
  LedgerModel(
    id: 'id',
    type: kIncome,
    tripAmount: 50000,
    passengers: 2,
    date: DateTime.now(),
    trip: 'Kampala to Masindi',
  ),
  LedgerModel(
    id: 'id',
    type: kWithdraw,
    tripAmount: 100000,
    passengers: 0,
    date: DateTime.now(),
    trip: '',
  ),
  LedgerModel(
    id: 'id',
    type: kIncome,
    tripAmount: 3000,
    passengers: 1,
    date: DateTime.now(),
    trip: 'Jinja to Mbale',
  ),
  LedgerModel(
      id: 'id',
      type: kIncome,
      tripAmount: 30000,
      passengers: 2,
      date: DateTime.now(),
      trip: 'Masaka to Kampala'),
  LedgerModel(
    id: 'id',
    type: kIncome,
    tripAmount: 50000,
    passengers: 1,
    date: DateTime.now(),
    trip: 'Kampala to Arua',
  ),
  LedgerModel(
    id: 'id',
    type: kWithdraw,
    passengers: 0,
    tripAmount: 10000,
    date: DateTime.now(),
    trip: '',
  ),
];
