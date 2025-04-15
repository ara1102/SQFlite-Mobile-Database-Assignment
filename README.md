# SQFlite-Mobile-Database-Assignment

## Contacts List App
This Flutter app demonstrates how to build a contact management system using SQFlite to store and manage contacts. Users can add, update, and delete contacts, and the app displays the list of contacts dynamically.

| NRP        | Name                        | Class
| ---------- | --------------------------- | -------
| 5025211102 | Adhira Riyanti Amanda       | PPB C

## Code Explanation
1. [main.dart](/lib/main.dart)
This is the entry point of the application. It ensures the database is initialized before the app is run.

    ```dart
    Future<void> main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await AppDatabase.instance.database;
        runApp(const MyApp());
    }
    ```

2. [home_page.dart](/lib/home_page.dart)
This file handles the main user interface and CRUD logic.

    - Controllers: `nameController` and `contactController` handle input text.
        ```dart
        TextEditingController nameController = TextEditingController();
        TextEditingController contactController = TextEditingController();
        ```
    - `contacts` List: Stores all contacts fetched from the database.
      ```dart
      List<Contact> contacts = List.empty(growable: true);
      ```
    - `refreshContacts()`: Fetches updated contact list from the DB.
      ```dart
      Future<void> refreshContacts() async {
          final data = await db.readAllContact();
          setState(() {
              contacts = data;
          });
      }
      ```
    - `selectedIndex`: Tracks which contact is being edited.
    - Buttons:
        - Save: Creates a new contact.
          ```dart
          ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      final newContact = Contact(name: name, contact: contact);
                      await db.createContact(newContact);

                      nameController.clear();
                      contactController.clear();

                      await refreshContacts();
                    }
                  },
                  child: const Text('Save'),
                ),
          ```
        - Update: Updates selected contact info.
          ```dart
          ElevatedButton(
                  onPressed: () async {
                    if (selectedIndex != -1) {
                      String updatedName = nameController.text.trim();
                      String updatedContact = contactController.text.trim();

                      if (updatedName.isNotEmpty && updatedContact.isNotEmpty) {
                        int contactId = contacts[selectedIndex].id!;

                        final updatedContactObj = Contact(
                          id: contactId,
                          name: updatedName,
                          contact: updatedContact,
                        );

                        await db.updateContact(updatedContactObj);

                        nameController.clear();
                        contactController.clear();
                        selectedIndex = -1;

                        await refreshContacts();
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
          ```
    - `initState()`: Loads all contacts when the widget is initialized.
      ```dart
      @override
      void initState() {
        super.initState();
        refreshContacts();
      }
      ```
    - `dispose()`: Closes the database and disposes of controllers when the widget is destroyed.
      ```dart
      @override
      void dispose() {
        db.database.then((database) => database.close());
        nameController.dispose();
        contactController.dispose();
        super.dispose();
      }
      ```

3. [contact.dart](/lib/contact.dart)

Defines the data model for a Contact. 

Contact Fields:
- id: unique identifier for each contact.
- name: name of the contact.
- contact: phone number.

Methods:
- `fromJson()`: Creates a Contact from a map (from database).
- `toJson()`: Converts a Contact into a map (for database).
- `copyWith()`: Allows creating a modified copy of a contact object.

4. [contact_card.dart](/lib/contact_card.dart)
This is a custom widget that displays a single contact in a styled card.

5. [app_database.dart](/lib/app_database.dart)
This file contains the database helper class, AppDatabase, that manages all SQflite operations using the sqflite package.
- `_initializeDB()`: Sets up the local database file using the path provider.
  ```dart
  Future<Database> _initializeDB(String fileName) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  ```
- `_createDB()`: Defines the schema for the contact table with CREATE TABLE.
  ```dart
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idField $idType,
        $nameField $textType,
        $contactField $textType
      )
    ''');
  ```
- `createContact()`: Inserts a new contact into the table.
  ```dart
  Future<Contact> createContact(Contact contact) async{
    final db = await instance.database;
    final id = await db.insert(tableName, contact.toJson());
    return contact.copyWith(id: id);
  }
  ```
- `readAllContact()`: Fetches all contacts as a list.
  ```dart
  Future<List<Contact>> readAllContact() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json)=> Contact.fromJson(json)).toList();
  }
  ```
- `updateContact()`: Updates a specific contact by id.
  ```dart
  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return db.update(
      tableName,
      contact.toJson(),
      where: "$idField = ?",
      whereArgs: [contact.id],
    );
  }
  ```
- `deleteContact()`: Deletes a specific contact by id.
  ```dart
  Future<int> deleteContact(Contact contact) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: "$idField = ?",
      whereArgs: [contact.id],
    );
  }
  ```
- `close()`: Closes the database connection.
  ```dart
  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }
  ```

