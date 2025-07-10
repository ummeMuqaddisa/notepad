import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['All notes', 'Work', 'Personal'];
  final TextEditingController searchController = TextEditingController();

  List<Note> userNotes = [];

  // Updated gradient colors to match your purple theme
  final List<LinearGradient> availableGradients = [
    const LinearGradient(colors: [Color(0xFF8F5E8B), Color(0xFF714A6D)]), // Your main purple
    const LinearGradient(colors: [Color(0xFFEFD3F5), Color(0xFFD7C4E2)]), // Your light purple
    const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]), // Blue
    const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]), // Green
    const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]), // Orange
    const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]), // Red
  ];

  List<Note> get filteredNotes {
    List<Note> filtered = userNotes;

    if (selectedTabIndex == 1) {
      filtered = filtered.where((note) => note.category == 'Work').toList();
    } else if (selectedTabIndex == 2) {
      filtered = filtered.where((note) => note.category == 'Personal').toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered.where((note) =>
      note.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          note.description.toLowerCase().contains(searchController.text.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  void toggleStar(int noteId) {
    setState(() {
      final noteIndex = userNotes.indexWhere((note) => note.id == noteId);
      if (noteIndex != -1) {
        userNotes[noteIndex].isStarred = !userNotes[noteIndex].isStarred;
      }
    });
  }

  void showAddNoteDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Personal';
    int selectedGradientIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Create New Note',
                style: TextStyle(
                  color: Color(0xFF714A6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Note Title',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                      items: ['Personal', 'Work'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Color Theme:',
                      style: TextStyle(
                        color: Color(0xFF714A6D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableGradients.asMap().entries.map((entry) {
                        int index = entry.key;
                        LinearGradient gradient = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedGradientIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: gradient,
                              shape: BoxShape.circle,
                              border: selectedGradientIndex == index
                                  ? Border.all(color: const Color(0xFF8F5E8B), width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF714A6D)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F5E8B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      addNewNote(
                        titleController.text,
                        descriptionController.text,
                        selectedCategory,
                        selectedGradientIndex,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Create Note',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addNewNote(String title, String description, String category, int gradientIndex) {
    setState(() {
      userNotes.add(Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
        time: _formatCurrentTime(),
        category: category,
        isStarred: false,
        gradient: availableGradients[gradientIndex],
      ));
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${now.day} ${months[now.month - 1]} ${hour == 0 ? 12 : hour}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  void deleteNote(int noteId) {
    setState(() {
      userNotes.removeWhere((note) => note.id == noteId);
    });
  }

  void editNote(Note note) {
    final titleController = TextEditingController(text: note.title);
    final descriptionController = TextEditingController(text: note.description);
    String selectedCategory = note.category;
    int selectedGradientIndex = availableGradients.indexOf(note.gradient);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Edit Note',
                style: TextStyle(
                  color: Color(0xFF714A6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Note Title',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8F5E8B), width: 2.0),
                        ),
                      ),
                      items: ['Personal', 'Work'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Color Theme:',
                      style: TextStyle(
                        color: Color(0xFF714A6D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableGradients.asMap().entries.map((entry) {
                        int index = entry.key;
                        LinearGradient gradient = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedGradientIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: gradient,
                              shape: BoxShape.circle,
                              border: selectedGradientIndex == index
                                  ? Border.all(color: const Color(0xFF8F5E8B), width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF714A6D)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F5E8B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      updateNote(
                        note.id,
                        titleController.text,
                        descriptionController.text,
                        selectedCategory,
                        selectedGradientIndex,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Update Note',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void updateNote(int noteId, String title, String description, String category, int gradientIndex) {
    setState(() {
      final noteIndex = userNotes.indexWhere((note) => note.id == noteId);
      if (noteIndex != -1) {
        userNotes[noteIndex] = Note(
          id: noteId,
          title: title,
          description: description,
          time: userNotes[noteIndex].time,
          category: category,
          isStarred: userNotes[noteIndex].isStarred,
          gradient: availableGradients[gradientIndex],
        );
      }
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      //Navigator.of(context).pushReplacementNamed('/login');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Background circles matching your login page
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFEFD3F5).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFD7C4E2).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header Section
                Container(
                  color: Colors.white.withOpacity(0.9),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Notes',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF714A6D),
                            ),
                          ),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    size: 28,
                                    color: Color(0xFF714A6D),
                                  ),
                                  if (userNotes.where((note) => note.isStarred).isNotEmpty)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF8F5E8B),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${userNotes.where((note) => note.isStarred).length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                onPressed: _logout,
                                icon: const Icon(
                                  Icons.logout,
                                  color: Color(0xFF714A6D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userNotes.isEmpty
                            ? 'Start creating your personal notes'
                            : 'Your daily notes that reminds you',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF714A6D),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFD3F5).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF8F5E8B).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search your notes...',
                            hintStyle: TextStyle(color: Color(0xFF714A6D)),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF714A6D),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tabs
                      Row(
                        children: tabs.asMap().entries.map((entry) {
                          int index = entry.key;
                          String tab = entry.value;
                          bool isSelected = selectedTabIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTabIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 24),
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF8F5E8B)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF8F5E8B)
                                      : const Color(0xFF714A6D),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Notes List or Empty State
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: filteredNotes.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add_outlined,
                            size: 80,
                            color: const Color(0xFF714A6D).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userNotes.isEmpty
                                ? 'No notes yet'
                                : 'No notes found',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF714A6D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userNotes.isEmpty
                                ? 'Tap the + button to create your first note'
                                : 'Try adjusting your search or filter',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF714A6D).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        return Dismissible(
                          key: Key(note.id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            deleteNote(note.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${note.title} deleted'),
                                backgroundColor: const Color(0xFF8F5E8B),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      userNotes.add(note);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => editNote(note),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: note.gradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          note.time,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => toggleStar(note.id),
                                          child: Icon(
                                            note.isStarred
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.white70,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      note.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      note.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        note.category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


      floatingActionButton: GestureDetector(
        onTap: showAddNoteDialog,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8F5E8B), Color(0xFF714A6D)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8F5E8B).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class Note {
  final int id;
  final String title;
  final String description;
  final String time;
  final String category;
  bool isStarred;
  final LinearGradient gradient;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.isStarred,
    required this.gradient,
  });
}