import 'package:flutter/material.dart';
import 'package:sqflite_mobile_database_assignment/app_database.dart';
import 'contact.dart';
import 'contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);


  Future<void> refreshContacts() async {
    final data = await db.readAllContact();
    setState(() {
      contacts = data;
    });
  }

  int selectedIndex = -1;

  final AppDatabase db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts List'),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Contact Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.number,
              maxLength: 15,
              decoration: const InputDecoration(
                hintText: 'Contact Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
              ],
            ),
            const SizedBox(height: 10),
            contacts.isEmpty
                ? const Text(
              'No Contact yet..',
              style: TextStyle(fontSize: 22),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) => ContactCard(
                  contact: contacts[index],
                  index: index,
                  onEdit: () {
                    nameController.text = contacts[index].name;
                    contactController.text = contacts[index].contact;
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  onDelete: () async {
                    await db.deleteContact(contacts[index]);
                    await refreshContacts();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    db.database.then((database) => database.close());
    nameController.dispose();
    contactController.dispose();
    super.dispose();
  }

}
