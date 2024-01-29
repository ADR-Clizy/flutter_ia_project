class Activity {
  final String title;
  final String place;
  final String preview;
  final double price;
  final String category;
  final int minParticipants;

  Activity(
      {required this.title,
      required this.place,
      required this.preview,
      required this.price,
      required this.category,
      required this.minParticipants});

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      title: map['title'],
      place: map['place'],
      preview: map['preview'],
      price: map['price'],
      category: map['category'],
      minParticipants: map['minParticipants'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'place': place,
      'preview': preview,
      'price': price,
      'category': category,
      'minParticipants': minParticipants,
    };
  }
}
