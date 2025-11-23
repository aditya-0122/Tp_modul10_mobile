class Item {
  final String id;          
  final String title;
  final String description;
  final String? createdAt; 

  Item({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
    };
  }
}
