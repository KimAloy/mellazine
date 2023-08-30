import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mellazine/main.dart';
import 'package:mellazine/pages/order_confirmation_page.dart';
import 'package:mellazine/widgets/google_text_field.dart';

import '../models/user_address_model.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String _selectedCountry = 'Uganda (UG)';
  String _selectedCountryPhoneCode = '+256';
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _apartmentEtcController = TextEditingController();
  TextEditingController _zipCodeController =
      TextEditingController(text: '000256');
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  bool _objectBoxUserExists = false;
  int _userAddressId = 0;

  @override
  void initState() {
    List<int> userIds = myObjectBox.usersExist();
    if (userIds.isNotEmpty) {
      // print('user exists');
      _objectBoxUserExists = true;
      final AddAddressModel userAddress =
          myObjectBox.getUserAddress(userIds[0])!;
      _userAddressId = userAddress.id;
      // print('userAddress.id: ${userAddress.id}');
      _selectedCountry = userAddress.country;
      _fullNameController = TextEditingController(text: userAddress.fullName);
      _streetAddressController =
          TextEditingController(text: userAddress.streetAddress);
      _apartmentEtcController =
          TextEditingController(text: userAddress.apartmentEtc);
      _zipCodeController = TextEditingController(text: userAddress.zipCode);
      _cityController = TextEditingController(text: userAddress.city);
      _stateController = TextEditingController(text: userAddress.state);
      _phoneController = TextEditingController(text: userAddress.phoneNumber);
    } else {
      // print('user does not exists');
      _phoneController = TextEditingController(text: _selectedCountryPhoneCode);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add an address'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),
                  _pickCountry(),
                  const SizedBox(height: 20),
                  _fullName(),
                  const SizedBox(height: 20),
                  _streetAddress(),
                  const SizedBox(height: 20),
                  _apartmentEtc(),
                  const SizedBox(height: 20),
                  _zipCode(),
                  const SizedBox(height: 20),
                  _city(),
                  const SizedBox(height: 20),
                  _state(),
                  const SizedBox(height: 20),
                  _phoneNumber(),
                  const SizedBox(height: 25),
                  _nextButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildErrorMessage(),
        FilledButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() => _errorMessage = '');
            bool isFormValid = _formKey.currentState!.validate();
            if (!isFormValid) {
              setState(
                  () => _errorMessage = 'Please fill in the fields marked *');
              return;
            } else {
              // print('customer_info_page:');
              // print('country: $_selectedCountry');
              // print('full name: ${_fullNameController.text.trim()}');
              // print('apartment etc.: ${_apartmentEtcController.text.trim()}');
              // print('zip code: ${_zipCodeController.text.trim()}');
              // print('city: ${_cityController.text.trim()}');
              // print('state: ${_stateController.text.trim()}');
              // print('phone number: ${_phoneController.text.trim()}');
              final AddAddressModel userAddress = AddAddressModel(
                country: _selectedCountry.trim(),
                fullName: _fullNameController.text.trim(),
                streetAddress: _streetAddressController.text.trim(),
                apartmentEtc: _apartmentEtcController.text.trim(),
                zipCode: _zipCodeController.text.trim(),
                city: _cityController.text.trim(),
                state: _stateController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
              );
              // add or update user to my_object_box
              if (_objectBoxUserExists == true) {
                // update userAddress in objectBox
                myObjectBox.updateUserAddress(
                  id: _userAddressId,
                  newUserAddress: userAddress,
                );
                // print('updated object');
              } else {
                // create user in objectBox
                myObjectBox.createUser(userAddress);
                // print('done creating new user');
              }
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const OrderConfirmationPage();
              }));
            }
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _fullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('*Full name (first and last name)'),
        GoogleTextField(
          hintText: '',
          controller: _fullNameController,
          validator: (value) => value!.isEmpty ? 'Please enter a name.' : null,
          textCapitalization: TextCapitalization.words,
        )
      ],
    );
  }

  Widget _phoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('*Phone number'),
        GoogleTextField(
          hintText: '',
          controller: _phoneController,
          validator: (value) => value!.isEmpty
              ? 'Please enter a phone number so we can call '
                  'if there are any issues with delivery.'
              : null,
          keyboardType: TextInputType.phone,
        )
      ],
    );
  }

  Widget _apartmentEtc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('Apartment, unit, building, floor, room, etc.'),
        GoogleTextField(
          hintText: '',
          controller: _apartmentEtcController,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _streetAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('*Street address'),
        GoogleTextField(
          hintText: '',
          controller: _streetAddressController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter a street address.' : null,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _zipCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('*Zip code'),
        GoogleTextField(
          hintText: '',
          controller: _zipCodeController,
          validator: (value) =>
              value!.isEmpty ? 'Please enter a valid zip code.' : null,
        )
      ],
    );
  }

  Widget _city() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('*City'),
        GoogleTextField(
          hintText: '',
          controller: _cityController,
          validator: (value) => value!.isEmpty ? 'Please enter a city.' : null,
          textCapitalization: TextCapitalization.words,
        )
      ],
    );
  }

  Widget _state() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitle('State'),
        GoogleTextField(
          hintText: '',
          controller: _stateController,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _pickCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _infoTitle('*Country'),
        ElevatedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
              // exclude: <String>['KN', 'MF'],
              favorite: <String>['US', 'GB', 'CN', 'CA'],
              //Optional. Shows phone code before the country name.
              showPhoneCode: true,
              onSelect: (Country country) {
                // print('Select country: ${country.displayName}');
                setState(() {
                  _selectedCountry = country.displayNameNoCountryCode;
                  _selectedCountryPhoneCode = country.phoneCode;
                });
              },
              // Optional. Sets the theme for the country list picker.
              countryListTheme: CountryListThemeData(
                // Optional. Sets the border radius for the bottomsheet.
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                // Optional. Styles the search field.
                inputDecoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Start typing to search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                    ),
                  ),
                ),
                // Optional. Styles the text in the search field
                searchTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                _selectedCountry,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTitle(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 3),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isEmpty
        ? const SizedBox.shrink()
        : Center(
            child: Column(
              children: [
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
  }
}
