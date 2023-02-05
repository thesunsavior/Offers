import '../model/Offer_util.dart';
import '../model/Offers.dart';
import '../utils/Offers_test_util.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  // File('../near_by.json').readAsString().then((String contents) {
  //   print(contents);
  //   var test = Offers(contents,check_in: DateTime.parse("2019-12-25"));
  //   print (test.getResponse());
  // });

  // unit test aims for branch coverage
  test("no offer",(){
    var generator = JsonGenerator(0, [], []);

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2023-10-11'));
    var res =offers.chooseBestOffers();
    expect (res.length,0);
  });

  test("invalid categories", () {
    var generator = JsonGenerator(3, // number of offer
        [2,1,2],  // number of merchants per offer
        [DateTime.parse("2022-05-10"),DateTime.parse("2022-06-11"),DateTime.parse("2022-05-01")], //Date valid of each offer
        [4,4,4]); // category of each offer

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2023-04-29'));
    var res =offers.chooseBestOffers();
    expect (res.length,0);
  });

  test("invalid validation date", () {
    var generator = JsonGenerator(3, // number of offer
        [2,1,2],  // number of merchants per offer
        [DateTime.parse("2022-05-10"),DateTime.parse("2022-06-11"),DateTime.parse("2022-05-01")], //Date valid of each offer
        [4,4,4]); // category of each offer

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2023-03-29'));
    var res =offers.chooseBestOffers();
    expect (res.length,0);
  });

  test("Only one valid category", () {
    var generator = JsonGenerator(3, // number of offer
        [2,1,2],  // number of merchants per offer
        [DateTime.parse("2022-05-10"),DateTime.parse("2022-05-11"),DateTime.parse("2022-05-01")], //Date valid of each offer
        [1,4,4]); // category of each offer

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2022-04-29'));
    var res =offers.chooseBestOffers();
    expect (res.length,1);
  });

  test("Only one valid category with many valid offer", () {
    var generator = JsonGenerator(3, // number of offer
        [1,1,1],  // number of merchants per offer
        [DateTime.parse("2022-05-10"),DateTime.parse("2022-05-11"),DateTime.parse("2022-05-05")], //Date valid of each offer
        [1,1,1],
        [
          Merchant(id: 1, name: "Merchant 1", distance: 0.2),
          Merchant(id: 2, name: "Merchant 2", distance: 0.3),
          Merchant(id: 3, name: "Merchant 3", distance: 0.5)
         ]); // category of each offer

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2022-04-29'));
    var res =offers.chooseBestOffers();
    expect (res.length,1);
    expect(res[0].merchants[0].distance, 0.2);
  });

  test("2 competing categories", () {
    var generator = JsonGenerator(4, // number of offer
        [1,1,1,2],  // number of merchants per offer
        [DateTime.parse("2022-05-10"),
          DateTime.parse("2022-05-11"),
          DateTime.parse("2022-05-05"),
          DateTime.parse("2022-05-07")], //Date valid of each offer
        [1,1,2,2],
        [
          Merchant(id: 1, name: "Merchant 1", distance: 0.2),
          Merchant(id: 1, name: "Merchant 2", distance: 0.3),
          Merchant(id: 1, name: "Merchant 3", distance: 0.5),
          Merchant(id: 1, name: "Merchant 4", distance: 0.4),
          Merchant(id: 2, name: "Merchant 5", distance: 0.6),
        ]); // category of each offer

    // generate json string
    String json = generator.jsonGenerate();
    print(json);

    var offers = Offers(json, check_in: DateTime.parse('2022-04-29'));
    var res =offers.chooseBestOffers();
    expect (res.length,2);
    expect(res[0].merchants[0].distance, 0.2);
    expect(res[1].merchants[0].distance, 0.4);
  });

  //
  // group("test class Offers",
  //         () => null);
}