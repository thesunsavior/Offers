import 'dart:convert';

import 'Offer.dart';

class Offers {
  late final List<Offer> _offers;
  DateTime check_in;
  Offers (String json, {required this.check_in}){

    // parse json string
    Map<String, dynamic> offers_map = jsonDecode(json);
    _offers = (offers_map["offers"] as List)
        .map((offer_map) => Offer.fromJson(offer_map))
        .toList();
  }

  List<Offer> chooseBestOffers() {
    // Offer to return in response
    var top_offers = List<Offer>.empty(growable: true);
    // filter offer to response
    for (var offer in _offers)
      if (offer.isValid(check_in)) {
        if (top_offers.isEmpty) {
          top_offers.add(offer);
        } else {
          var temp = offer;
          for (int i = 0; i < top_offers.length; i++) {
            if (top_offers[i].compareTo(temp) > 0) {
              var temp_swap = temp;
              temp = top_offers[i];
              top_offers[i] = temp_swap;
            }

            if (temp.category == top_offers[i].category)
              break;

            if (i == 0 && top_offers.length < 2) {
              top_offers.add(temp);
              break;
            }
          }
        }
      }

    return top_offers;
  }

  // generate json response
  String getResponse () {
    var top_offers = chooseBestOffers();
    Map<String, dynamic> response = {
      'Offers': top_offers.map((offer) => offer.toJson()).toList()
    };

    return jsonEncode(response);
  }
}
