class Play {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String date;
  final String time;
  final String location;
  final String url;

  Play({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.url,
  });

  factory Play.fromJson(Map<String, dynamic> json) {
    return Play(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? 'No description provided',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? 'Unknown location',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'url': url,
    };
  }
}
