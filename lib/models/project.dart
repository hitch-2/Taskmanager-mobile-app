class Project {
  final int? id;
  final String name;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? logo;

  Project({this.id, required this.name, this.description, this.startDate, this.endDate, this.logo});

  factory Project.fromJson(Map<String, dynamic> j) => Project(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    startDate: j['start_date'],
    endDate: j['end_date'],
    logo: j['logo'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'start_date': startDate,
    'end_date': endDate,
    'logo': logo,
  };
}
