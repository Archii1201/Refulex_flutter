class OrderModel {
  final String id;
  final String pumpId;
  final double litres;
  final double fuelCost;
  final double deliveryCharge;
  final double totalAmount;
  final int distanceMeters;
  final String status;

  OrderModel({
    required this.id,
    required this.pumpId,
    required this.litres,
    required this.fuelCost,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.distanceMeters,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      pumpId: json['pump']?['_id'] ?? json['pump'] ?? '',
      litres: (json['litres'] ?? 0).toDouble(),
      fuelCost: (json['fuelCost'] ?? json['fuel_cost'] ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? json['delivery_charge'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0).toDouble(),
      distanceMeters: (json['distance_meters'] ?? 0) as int,
      status: json['status'] ?? 'pending',
    );
  }
}