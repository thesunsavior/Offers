import 'dart:convert';
import 'dart:math';

import '../model/Merchant.dart';
import '../model/Offer.dart';

// generate json string to test
class JsonGenerator {
  int number_of_offer;
  List<DateTime> valid_to; // valid date of each offer
  List<int> number_of_merchant;
  List<int> offer_categories; // category of each offer
  List<Merchant> input_merchants = List.empty(growable: true); // merchant to be included in generated offer

  JsonGenerator(this.number_of_offer, this.number_of_merchant, this.valid_to,
      [this.offer_categories = const <int>[],
        this.input_merchants = const <Merchant>[]]);

  String getRequest() {
    var offers = List<Offer>.empty(growable: true);

    var merchant_index = 0;
    for (int i = 0; i < number_of_offer; i++) {
      var merchants = List<Merchant>.empty(growable: true);
      for (int j = 0; j < number_of_merchant[i]; j++) {
        // if there is no ListOfMerchant than we assign randomly
        if (merchant_index >= input_merchants.length) {
          merchants
              .add(Merchant(id: j+1, name: "Merchant $j", distance: Random().nextDouble()));
        } else {
          merchants.add(input_merchants[merchant_index]);
          merchant_index += 1;
        }
      }

      offers.add(Offer(
          id: i,
          title: "",
          description: "",
          category: (i > offer_categories.length)
              ? Random().nextInt(4) + 1
              : offer_categories[i],
          merchants: merchants,
          valid_to: this.valid_to[i]));
    }

    Map<String, dynamic> request = {
      "offers": offers.map((offer) => offer.toJson()).toList()
    };

    return jsonEncode(request);
  }
}
