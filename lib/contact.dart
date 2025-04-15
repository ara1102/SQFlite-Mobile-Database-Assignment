const String tableName = "contacts";
const String idField = "_id";
const String nameField = "name";
const String contactField = "contact";

const List<String> contactColumns = [
  idField,
  nameField,
  contactField,
];

const String boolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable= "TEXT";
const String textType = "TEXT NOT NULL";

class Contact {
  int? id;
  String name;
  String contact;

  Contact({
    this.id,
    required this.name,
    required this.contact
  });

  static Contact fromJson(Map<String, dynamic> json) => Contact(
    id: json[idField] as int?,
    name: json[nameField] as String,
    contact: json[contactField] as String,
  );

  Map<String, dynamic> toJson() => {
    idField: id,
    nameField: name,
    contactField: contact
  };

  Contact copyWith({
    int? id,
    String? name,
    String? contact
  }) =>
      Contact(
        id: id ?? this.id,
        name: name ?? this.name,
        contact: contact ?? this.contact,
      );

}