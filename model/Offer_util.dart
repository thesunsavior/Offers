class Merchant {
  final int id;
  final String name;
  final double distance;
  Merchant({required this.id, required this.name, required this.distance});
  Merchant.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.name = json["name"],
        this.distance = json["distance"];

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "distance": distance};
}

class Offer implements Comparable<Offer> {
  final int id;
  final String title;
  final String description;
  final int category;
  final List<Merchant> merchants;
  final DateTime valid_to;

  Offer(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.merchants,
      required this.valid_to}) {
    assert(merchants.length > 0, "There should be at least a merchant");

    // find closest merchant to the position
    var closest_merchant =
        merchants.reduce((a, b) => a.distance < b.distance ? a : b);

    // keep only the nearest one
    merchants.clear();
    merchants.add(closest_merchant);
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        merchants: (json["merchants"] as List)
            .map((merchant_json) => Merchant.fromJson(merchant_json))
            .toList(),
        valid_to: DateTime.parse(json["valid_to"]));
  }
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');
  Map<String, dynamic> toJson() {
    var formatted_date =
        "${this.valid_to.year}"
        "-${this.valid_to.month < 10 ? "0" + this.valid_to.month.toString() : this.valid_to.month}"
        "-${this.valid_to.day < 10 ? "0" + this.valid_to.day.toString() : this.valid_to.day}";
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "category": this.category,
      "merchants": this.merchants.map((merchant) => merchant.toJson()).toList(),
      "valid_to": formatted_date
    };
  }

  @override
  int compareTo(Offer other) =>
      (this.merchants[0].distance - other.merchants[0].distance) >= 0 ? 1 : -1;

  bool isValid(DateTime check_in_date) {
    if (this.category == 3) return false;

    if (this.valid_to.compareTo(check_in_date) < 0 ||
        check_in_date.add(Duration(days: 5)).compareTo(this.valid_to) > 0)
      return false;

    return true;
  }
}
