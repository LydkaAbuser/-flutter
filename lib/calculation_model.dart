class Calculation {
  final int? id;
  final double initialVelocity;
  final double finalVelocity;
  final double time;
  final double acceleration;
  final String movementType;
  final DateTime createdAt;

  Calculation({
    this.id,
    required this.initialVelocity,
    required this.finalVelocity,
    required this.time,
    required this.acceleration,
    required this.movementType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'initialVelocity': initialVelocity,
      'finalVelocity': finalVelocity,
      'time': time,
      'acceleration': acceleration,
      'movementType': movementType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'],
      initialVelocity: map['initialVelocity'],
      finalVelocity: map['finalVelocity'],
      time: map['time'],
      acceleration: map['acceleration'],
      movementType: map['movementType'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}