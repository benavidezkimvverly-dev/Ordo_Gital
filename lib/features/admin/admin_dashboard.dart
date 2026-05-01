import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordogital/core/theme/app_theme.dart';
import 'package:ordogital/core/theme/liturgical_season.dart';
import 'package:ordogital/features/admin/admin_login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final season = LiturgicalCalendar.getCurrentSeason();
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.people, 'label': 'User Management'},
    {'icon': Icons.menu_book, 'label': 'Liturgical Content'},
    {'icon': Icons.calendar_month, 'label': 'Mass Scheduler'},
    {'icon': Icons.assignment_ind, 'label': 'Duty Assignment'},
    {'icon': Icons.savings, 'label': 'Financial Tracker'},
    {'icon': Icons.campaign, 'label': 'Announcements'},
    {'icon': Icons.sms, 'label': 'SMS Gateway'},
    {'icon': Icons.music_note, 'label': 'Hymnary'},
  ];

  Widget _buildContent() {
    final primary = LiturgicalTheme.getPrimaryColor(season);
    switch (_selectedIndex) {
      case 0:
        return const UserManagementPanel();
      case 2:
        return const MassSchedulerPanel();
      case 3:
        return const DutyAssignmentPanel();
      case 4:
        return const ParishProjectsPanel();
      case 5:
        return const AnnouncementsPanel();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _menuItems[_selectedIndex]['icon'],
                size: 64,
                color: primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                _menuItems[_selectedIndex]['label'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming soon...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = LiturgicalTheme.getPrimaryColor(season);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: const Color(0xFF1A2C5B),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.church,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'OrdoGital',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const Text(
                        'Admin Portal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white60,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['label'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white60, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: TextStyle(fontSize: 13, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _menuItems[_selectedIndex]['label'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2C5B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Parish Admin',
                          style: TextStyle(
                            fontSize: 13,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── User Management Panel ────────────────────────────────────────────────────

class UserManagementPanel extends StatefulWidget {
  const UserManagementPanel({super.key});

  @override
  State<UserManagementPanel> createState() => _UserManagementPanelState();
}

class _UserManagementPanelState extends State<UserManagementPanel> {
  final _firestore = FirebaseFirestore.instance;

  final List<String> _ministryTypes = [
    'lector',
    'altar_server',
    'commentator',
    'choir',
    'usher',
  ];

  void _showAddDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final accessKeyController = TextEditingController();
    String selectedType = 'lector';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Ministry Member',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Full Name', Icons.person),
              const SizedBox(height: 12),
              _buildTextField(phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 12),
              _buildTextField(accessKeyController, 'Access Key', Icons.key),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setStateDialog) =>
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Ministry Type',
                        prefixIcon: const Icon(
                          Icons.church,
                          color: Color(0xFF1A2C5B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _ministryTypes
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setStateDialog(() => selectedType = val!),
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  accessKeyController.text.isEmpty)
                return;
              await _firestore.collection('users').add({
                'full_name': nameController.text.trim(),
                'phone': phoneController.text.trim(),
                'access_key': accessKeyController.text.trim(),
                'ministry_type': selectedType,
                'role': 'ministry',
                'is_active': true,
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final nameController = TextEditingController(text: data['full_name']);
    final phoneController = TextEditingController(text: data['phone']);
    final accessKeyController = TextEditingController(text: data['access_key']);
    String selectedType = data['ministry_type'] ?? 'lector';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Ministry Member',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Full Name', Icons.person),
              const SizedBox(height: 12),
              _buildTextField(phoneController, 'Phone Number', Icons.phone),
              const SizedBox(height: 12),
              _buildTextField(accessKeyController, 'Access Key', Icons.key),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setStateDialog) =>
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Ministry Type',
                        prefixIcon: const Icon(
                          Icons.church,
                          color: Color(0xFF1A2C5B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _ministryTypes
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setStateDialog(() => selectedType = val!),
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await _firestore.collection('users').doc(doc.id).update({
                'full_name': nameController.text.trim(),
                'phone': phoneController.text.trim(),
                'access_key': accessKeyController.text.trim(),
                'ministry_type': selectedType,
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Sigurado ka bang gusto mong i-delete ito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestore.collection('users').doc(docId).delete();
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A2C5B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Ministry Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2C5B),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Member'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2C5B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('role', isEqualTo: 'ministry')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Walang ministry members pa.'),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF1A2C5B),
                        child: Text(
                          (data['full_name'] ?? '?')[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        data['full_name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${data['ministry_type'] ?? ''} • ${data['phone'] ?? ''} • Key: ${data['access_key'] ?? ''}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF1A2C5B),
                            ),
                            onPressed: () => _showEditDialog(doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(doc.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mass Scheduler Panel ─────────────────────────────────────────────────────

class MassSchedulerPanel extends StatefulWidget {
  const MassSchedulerPanel({super.key});

  @override
  State<MassSchedulerPanel> createState() => _MassSchedulerPanelState();
}

class _MassSchedulerPanelState extends State<MassSchedulerPanel> {
  final _firestore = FirebaseFirestore.instance;

  final List<String> _days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  void _showAddDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final dateController = TextEditingController();
    final notesController = TextEditingController();
    bool isRecurring = false;
    int selectedDay = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Mass Schedule',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title (e.g. Sunday Mass)',
                    prefixIcon: const Icon(
                      Icons.church,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: 'Time (e.g. 08:00)',
                    prefixIcon: const Icon(
                      Icons.access_time,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Switch(
                      value: isRecurring,
                      onChanged: (val) =>
                          setStateDialog(() => isRecurring = val),
                      activeColor: const Color(0xFF1A2C5B),
                    ),
                    const Text('Recurring (Weekly)'),
                  ],
                ),
                const SizedBox(height: 8),
                if (isRecurring)
                  DropdownButtonFormField<int>(
                    value: selectedDay,
                    decoration: InputDecoration(
                      labelText: 'Day of Week',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF1A2C5B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: List.generate(
                      7,
                      (i) => DropdownMenuItem(value: i, child: Text(_days[i])),
                    ),
                    onChanged: (val) =>
                        setStateDialog(() => selectedDay = val!),
                  )
                else
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (e.g. 2026-05-01)',
                      prefixIcon: const Icon(
                        Icons.date_range,
                        color: Color(0xFF1A2C5B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: const Icon(
                      Icons.note,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (titleController.text.isEmpty || timeController.text.isEmpty)
                return;
              await _firestore.collection('mass_schedules').add({
                'title': titleController.text.trim(),
                'mass_time': timeController.text.trim(),
                'mass_date': dateController.text.trim(),
                'is_recurring': isRecurring,
                'day_of_week': isRecurring ? selectedDay : null,
                'notes': notesController.text.trim(),
                'recurrence': isRecurring ? 'weekly' : null,
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text('Sigurado ka bang gusto mong i-delete ito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestore.collection('mass_schedules').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Mass Schedules',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2C5B),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2C5B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('mass_schedules')
                  .orderBy('mass_time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Walang mass schedules pa.'));
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isRecurring = data['is_recurring'] == true;
                    final days = [
                      'Sunday',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                    ];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF1A2C5B),
                        child: Icon(
                          Icons.church,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        data['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${data['mass_time'] ?? ''} • ${isRecurring ? 'Every ${days[(data['day_of_week'] ?? 0)]}' : data['mass_date'] ?? ''}'
                        '${data['notes'] != null && data['notes'].toString().isNotEmpty ? ' • ${data['notes']}' : ''}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSchedule(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Duty Assignment Panel ────────────────────────────────────────────────────

class DutyAssignmentPanel extends StatefulWidget {
  const DutyAssignmentPanel({super.key});

  @override
  State<DutyAssignmentPanel> createState() => _DutyAssignmentPanelState();
}

class _DutyAssignmentPanelState extends State<DutyAssignmentPanel> {
  final _firestore = FirebaseFirestore.instance;

  void _showAddDialog() async {
    // Kunin ang ministry members at mass schedules
    final usersSnap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'ministry')
        .get();
    final schedulesSnap = await _firestore
        .collection('mass_schedules')
        .orderBy('mass_time')
        .get();

    if (usersSnap.docs.isEmpty || schedulesSnap.docs.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kailangan muna ng ministry members at mass schedules!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? selectedUserId;
    String? selectedScheduleId;
    String selectedRole = 'lector';
    String massDate = '';

    final users = usersSnap.docs;
    final schedules = schedulesSnap.docs;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Assign Duty',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Piliin ang Ministry Member
                DropdownButtonFormField<String>(
                  value: selectedUserId,
                  decoration: InputDecoration(
                    labelText: 'Ministry Member',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: users.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(
                        '${data['full_name']} (${data['ministry_type']})',
                      ),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setStateDialog(() => selectedUserId = val),
                ),
                const SizedBox(height: 12),
                // Piliin ang Mass Schedule
                DropdownButtonFormField<String>(
                  value: selectedScheduleId,
                  decoration: InputDecoration(
                    labelText: 'Mass Schedule',
                    prefixIcon: const Icon(
                      Icons.church,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: schedules.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text('${data['title']} - ${data['mass_time']}'),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setStateDialog(() => selectedScheduleId = val),
                ),
                const SizedBox(height: 12),
                // Role
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: const Icon(
                      Icons.assignment_ind,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'lector', child: Text('Lector')),
                    DropdownMenuItem(
                      value: 'altar_server',
                      child: Text('Altar Server'),
                    ),
                    DropdownMenuItem(
                      value: 'commentator',
                      child: Text('Commentator'),
                    ),
                    DropdownMenuItem(value: 'choir', child: Text('Choir')),
                    DropdownMenuItem(value: 'usher', child: Text('Usher')),
                  ],
                  onChanged: (val) => setStateDialog(() => selectedRole = val!),
                ),
                const SizedBox(height: 12),
                // Date
                TextField(
                  onChanged: (val) => massDate = val,
                  decoration: InputDecoration(
                    labelText: 'Mass Date (e.g. 2026-05-04)',
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (selectedUserId == null || selectedScheduleId == null) return;

              final userData =
                  users.firstWhere((d) => d.id == selectedUserId).data()
                      as Map<String, dynamic>;
              final scheduleData =
                  schedules.firstWhere((d) => d.id == selectedScheduleId).data()
                      as Map<String, dynamic>;

              await _firestore.collection('duty_assignments').add({
                'user_access_key': userData['access_key'],
                'user_name': userData['full_name'],
                'user_phone': userData['phone'],
                'role_assigned': selectedRole,
                'mass_title': scheduleData['title'],
                'mass_time': scheduleData['mass_time'],
                'mass_date': massDate,
                'confirmed': false,
                'sms_sent': false,
              });

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _deleteDuty(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Duty'),
        content: const Text('Sigurado ka bang gusto mong i-delete ito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestore.collection('duty_assignments').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Duty Assignments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2C5B),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Assign Duty'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2C5B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('duty_assignments').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Walang duty assignments pa.'),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isConfirmed = data['confirmed'] == true;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isConfirmed
                            ? Colors.green
                            : const Color(0xFF1A2C5B),
                        child: Icon(
                          isConfirmed ? Icons.check : Icons.assignment_ind,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        data['user_name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${data['role_assigned'] ?? ''} • ${data['mass_title'] ?? ''} • ${data['mass_time'] ?? ''} • ${data['mass_date'] ?? ''}'
                        '${isConfirmed ? ' ✅ Confirmed' : ' ⏳ Pending'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDuty(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Parish Projects Panel ────────────────────────────────────────────────────

class ParishProjectsPanel extends StatefulWidget {
  const ParishProjectsPanel({super.key});

  @override
  State<ParishProjectsPanel> createState() => _ParishProjectsPanelState();
}

class _ParishProjectsPanelState extends State<ParishProjectsPanel> {
  final _firestore = FirebaseFirestore.instance;

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final goalController = TextEditingController();
    final currentController = TextEditingController();
    bool isCompleted = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Parish Project',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Project Title',
                    prefixIcon: const Icon(
                      Icons.construction,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Goal Amount (₱)',
                    prefixIcon: const Icon(
                      Icons.savings,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: currentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Current Amount (₱)',
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Switch(
                      value: isCompleted,
                      onChanged: (val) =>
                          setStateDialog(() => isCompleted = val),
                      activeColor: const Color(0xFF1A2C5B),
                    ),
                    const Text('Completed'),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              await _firestore.collection('parish_projects').add({
                'title': titleController.text.trim(),
                'description': descController.text.trim(),
                'goal_amount': double.tryParse(goalController.text) ?? 0.0,
                'current_amount':
                    double.tryParse(currentController.text) ?? 0.0,
                'is_completed': isCompleted,
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final titleController = TextEditingController(text: data['title']);
    final descController = TextEditingController(text: data['description']);
    final goalController = TextEditingController(
      text: (data['goal_amount'] ?? 0).toString(),
    );
    final currentController = TextEditingController(
      text: (data['current_amount'] ?? 0).toString(),
    );
    bool isCompleted = data['is_completed'] ?? false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Parish Project',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Project Title',
                    prefixIcon: const Icon(
                      Icons.construction,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Goal Amount (₱)',
                    prefixIcon: const Icon(
                      Icons.savings,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: currentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Current Amount (₱)',
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF1A2C5B),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Switch(
                      value: isCompleted,
                      onChanged: (val) =>
                          setStateDialog(() => isCompleted = val),
                      activeColor: const Color(0xFF1A2C5B),
                    ),
                    const Text('Completed'),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await _firestore
                  .collection('parish_projects')
                  .doc(doc.id)
                  .update({
                    'title': titleController.text.trim(),
                    'description': descController.text.trim(),
                    'goal_amount': double.tryParse(goalController.text) ?? 0.0,
                    'current_amount':
                        double.tryParse(currentController.text) ?? 0.0,
                    'is_completed': isCompleted,
                  });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteProject(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Sigurado ka bang gusto mong i-delete ito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestore.collection('parish_projects').doc(docId).delete();
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Parish Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2C5B),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2C5B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('parish_projects').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Walang parish projects pa.'),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final goal =
                        (data['goal_amount'] as num?)?.toDouble() ?? 0.0;
                    final current =
                        (data['current_amount'] as num?)?.toDouble() ?? 0.0;
                    final progress = goal > 0
                        ? (current / goal).clamp(0.0, 1.0)
                        : 0.0;
                    final isCompleted = data['is_completed'] == true;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCompleted
                            ? Colors.green
                            : const Color(0xFF1A2C5B),
                        child: Icon(
                          isCompleted ? Icons.check : Icons.construction,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        data['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₱${_formatAmount(current)} / ₱${_formatAmount(goal)} • ${(progress * 100).toStringAsFixed(1)}%',
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted
                                  ? Colors.green
                                  : const Color(0xFF1A2C5B),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF1A2C5B),
                            ),
                            onPressed: () => _showEditDialog(doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProject(doc.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Announcements Panel ──────────────────────────────────────────────────────

class AnnouncementsPanel extends StatefulWidget {
  const AnnouncementsPanel({super.key});

  @override
  State<AnnouncementsPanel> createState() => _AnnouncementsPanelState();
}

class _AnnouncementsPanelState extends State<AnnouncementsPanel> {
  final _firestore = FirebaseFirestore.instance;
  final List<String> _categories = ['general', 'urgent', 'feast', 'activity'];

  void _showAddDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedCategory = 'general';
    String selectedRole = 'all';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Announcement',
          style: TextStyle(
            color: Color(0xFF1A2C5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title, color: Color(0xFF1A2C5B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message',
                  prefixIcon: const Icon(
                    Icons.message,
                    color: Color(0xFF1A2C5B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setStateDialog) => Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(
                          Icons.category,
                          color: Color(0xFF1A2C5B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _categories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setStateDialog(() => selectedCategory = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Target',
                        prefixIcon: const Icon(
                          Icons.people,
                          color: Color(0xFF1A2C5B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(
                          value: 'parishioner',
                          child: Text('Parishioner'),
                        ),
                        DropdownMenuItem(
                          value: 'ministry',
                          child: Text('Ministry'),
                        ),
                      ],
                      onChanged: (val) =>
                          setStateDialog(() => selectedRole = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2C5B),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (titleController.text.isEmpty || bodyController.text.isEmpty)
                return;
              await _firestore.collection('announcements').add({
                'title': titleController.text.trim(),
                'body': bodyController.text.trim(),
                'category': selectedCategory,
                'target_role': selectedRole,
                'is_active': true,
                'publish_at': DateTime.now().toIso8601String(),
              });
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _deleteAnnouncement(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Sigurado ka bang gusto mong i-delete ito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestore.collection('announcements').doc(docId).delete();
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'urgent':
        return const Color(0xFFDC2626);
      case 'feast':
        return const Color(0xFFD97706);
      case 'activity':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2C5B),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Post Announcement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2C5B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('announcements')
                  .orderBy('publish_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Walang announcements pa.'));
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final category = data['category'] ?? 'general';
                    final categoryColor = _getCategoryColor(category);
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.campaign,
                          color: categoryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        data['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${category.toUpperCase()} • ${data['target_role'] ?? 'all'} • ${data['publish_at'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAnnouncement(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
