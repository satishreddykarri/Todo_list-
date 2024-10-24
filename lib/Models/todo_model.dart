class TodoModel {
  int? id;
  late String title;
  late String description;
  late String status;
  late String date;

  TodoModel(this.title, this.description, this.status, this.date);

  TodoModel.withID(
      this.id, this.title, this.description, this.status, this.date);
 
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) {
      map["id"] = id;
    }
    map["title"] = title;
    map["description"] = description;
    map["status"] = status;
    map["date"] = date;
    return map;
  }

  TodoModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] != null ? map["id"] as int : null;
    title = map["title"] != null ? map["title"] as String : '';
    description =
        map["description"] != null ? map["description"] as String : '';
    status = map["status"] != null ? map["status"] as String : '';
    date = map["date"] != null ? map["date"] as String : '';
  }
}
