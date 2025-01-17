import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SelectUserWithSearch extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final Function(Map<String, dynamic>) onUserSelected;

  const SelectUserWithSearch({
    super.key, 
    required this.users, 
    required this.onUserSelected
  });

  @override
  State<SelectUserWithSearch> createState() => _SelectUserWithSearchState();
}

class _SelectUserWithSearchState extends State<SelectUserWithSearch> {
  var searchValue = '';

  Map<String, Map<String, dynamic>> get filteredUsers => {
    for (final user in widget.users)
      if (user['name'].toLowerCase().contains(searchValue.toLowerCase()) || user['email'].toLowerCase().contains(searchValue.toLowerCase()))
        user['id'].toString(): user
  };

  @override
  Widget build(BuildContext context) {
    return ShadSelect<String>.withSearch(
      minWidth: 300,
      maxWidth: 300,
      placeholder: const Text('Select'),
      onSearchChanged: (value) => setState(() => searchValue = value),
      searchPlaceholder: const Text('Search by name or email'),
      options: [
        if (filteredUsers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No users found'),
          ),
        ...widget.users.map(
          (user) {
            return Offstage(
              offstage: !filteredUsers.containsKey(user['id'].toString()),
              child: ShadOption(
                value: user['id'].toString(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['name']),
                    Text(
                      user['email'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
      selectedOptionBuilder: (context, value) {
        final selectedUser = widget.users.firstWhere(
          (user) => user['id'].toString() == value
        );
        return Text(selectedUser['name']);
      },
      onChanged: (value) {
        if (value != null) {
          final selectedUser = widget.users.firstWhere(
            (user) => user['id'].toString() == value
          );
          widget.onUserSelected(selectedUser);
        }
      },
    );
  }
}