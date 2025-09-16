class PumpModel {
  final String id;
  final String name;
  final double fuelPricePerLitre;
  final double lat;
  final double lng;
  final String ownerId;

  PumpModel({
    required this.id,
    required this.name,
    required this.fuelPricePerLitre,
    required this.lat,
    required this.lng,
    required this.ownerId,
  });

  factory PumpModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['location']?['coordinates'] as List?) ?? [];
    final lng = coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0;
    final lat = coords.length > 1 ? (coords[1] as num).toDouble() : 0.0;
    return PumpModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      fuelPricePerLitre: (json['fuelPricePerLitre'] ?? json['fuel_price_per_litre'] ?? 0).toDouble(),
      lat: lat,
      lng: lng,
      ownerId: json['owner']?['_id'] ?? json['owner'] ?? '',
    );
  }
}