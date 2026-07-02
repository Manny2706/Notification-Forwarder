class AppInfo {
  final String name;
  final String packageName;

  bool selected;

  AppInfo({
    required this.name,
    required this.packageName,
    this.selected = false,
  });

  factory AppInfo.fromMap(Map<dynamic, dynamic> map) {
    return AppInfo(name: map["name"] ?? "", packageName: map["package"] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "package": packageName};
  }
}
