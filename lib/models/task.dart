class Task {
  final int? id;
  final int projectId;
  final String title;
  final String? time;
  final String? status;

  Task({this.id, required this.projectId, required this.title, this.time, this.status});

  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'],
    projectId: j['project_id'],
    title: j['title'],
    time: j['time'],
    status: j['status'],
  );

  Map<String, dynamic> toJson() => {
    'project_id': projectId,
    'title': title,
    'time': time,
    'status': status,
  };
}
