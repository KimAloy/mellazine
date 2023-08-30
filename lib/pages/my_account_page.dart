import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mellazine/repository/number_formatter.dart';
import '../constants/constants.dart';
import '../models/ledger_model.dart';
import '../models/person_model.dart';

const String kAccountHistory = 'Account History';
const String kOrders = 'Orders';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

Color _myColor = Colors.blue.shade800;

class _MyAccountPageState extends State<MyAccountPage> {
  final PersonModel currentUser = kimbowaCurrentDriver;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('My account'),
          bottom: const TabBar(
            tabs: [
              Tab(text: kAccountHistory),
              Tab(text: kOrders),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _accountHistory(),
            _orders(),
          ],
        ),
      ),
    );
  }

  // return Scaffold(
  //     body: DefaultTabController(
  //       length: 2,
  //       child: TabBarView(
  //         children: [
  //           _accountHistory(),
  //           _orders(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.icon(
            onPressed: () async {
              // todo implement, copy from Mushaho
              print('todo implement, copy from Mushaho');
            },
            icon: const Icon(Icons.logout_outlined),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _incomeHistory() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accountLedgerList.length,
      itemBuilder: (context, index) {
        final LedgerModel item = accountLedgerList[index];
        bool isIncome = item.type.toLowerCase() == kIncome;
        bool isWithdraw = item.type.toLowerCase() == kWithdraw;
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          leading: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            size: 22,
            color: isIncome ? Colors.green : Colors.red,
          ),
          title: Text(isWithdraw ? 'Withdraw' : item.trip),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isWithdraw
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passengers: ${item.passengers}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
              Text(
                DateFormat.yMd().add_jm().format(item.date),
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          trailing: Text(
            'Ush ${numFormat(num: 50000)}',
            style: TextStyle(
              color: isIncome ? _myColor : Colors.red,
              fontSize: 16,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Widget _userInformation() {
    const double iconSize = 18;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              currentUser.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.account_circle_outlined,
              color: _myColor,
              size: iconSize,
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              // _userPhone,
              '+256789456258',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.phone_android_outlined,
              size: iconSize,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              currentUser.email,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.mail_outlined,
              color: Colors.red.shade800,
              size: iconSize,
            ),
          ],
        ),
      ],
    );
  }

  Widget _accountBalanceCardWidget() {
    return Container(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 2),
      height: 220,
      // height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'B A L A N C E',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Ush ${numFormat(num: currentUser.accountBalance)}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // todo: implement withdraw funds
                print('my_account_page: withdraw tapped');
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                    ),
                  ),
                  const Text(' Withdraw')
                ],
              ),
            ),
            _userInformation(),
          ],
        ),
      ),
    );
  }


  Widget _pageTitle({required String title}) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: _myColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }


  Widget _orders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.brown,
          width: double.infinity,
          height: 400,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _accountHistory() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _accountBalanceCardWidget(),
          ),
          const SizedBox(height: 20),
          _logoutButton(),
          const SizedBox(height: 10),
          _pageTitle(title: kAccountHistory),
          const SizedBox(height: 10),
          _incomeHistory(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
