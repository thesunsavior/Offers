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