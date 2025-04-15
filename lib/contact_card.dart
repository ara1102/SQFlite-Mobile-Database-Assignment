import 'package:flutter/material.dart';
import 'contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contact.name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contact.contact),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                onTap: onEdit,
                child: const Icon(Icons.edit),
              ),
              InkWell(
                onTap: onDelete,
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
