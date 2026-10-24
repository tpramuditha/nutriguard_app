import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../food_scanner/data/models/food_log_model.dart';
import '../../../food_scanner/data/repositories/food_log_repository.dart';
import '../../../../app/routes/route_names.dart';

class FoodHistoryPage extends StatefulWidget {
  const FoodHistoryPage({super.key});

  @override
  State<FoodHistoryPage> createState() => _FoodHistoryPageState();
}

class _FoodHistoryPageState extends State<FoodHistoryPage> {
  final FoodLogRepository _repository = FoodLogRepository();

  late Future<List<FoodLogModel>> _logsFuture;

  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  bool _showTimeline = false;

  static const _filters = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  static const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final user = FirebaseAuth.instance.currentUser;

    _logsFuture = user == null
        ? Future.error(StateError('Please log in to view food history.'))
        : _repository.getFoodLogs(userId: user.uid);
  }

  Future<void> _refresh() async {
    setState(_loadLogs);

    try {
      await _logsFuture;
    } catch (_) {
      // FutureBuilder displays the error message.
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + days,
      );
    });
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dateText(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final prefix = _sameDay(date, DateTime.now()) ? 'Today, ' : '';

    return '$prefix${date.day} '
        '${months[date.month - 1]} ${date.year}';
  }

  List<FoodLogModel> _logsForDate(List<FoodLogModel> logs) {
    return logs.where((log) {
      return _sameDay(log.loggedAt.toLocal(), _selectedDate);
    }).toList();
  }

  List<FoodLogModel> _applyFilter(List<FoodLogModel> logs) {
    if (_selectedFilter == 'All') return logs;

    final mealType = _selectedFilter == 'Snacks' ? 'Snack' : _selectedFilter;

    return logs.where((log) => log.mealType == mealType).toList();
  }

  double _total(List<FoodLogModel> logs, double Function(FoodLogModel) value) {
    return logs.fold<double>(0, (sum, log) => sum + value(log));
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Food History Date',
    );

    if (!mounted || selectedDate == null) return;

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  Widget _dateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _changeDate(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          _dateText(_selectedDate),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        IconButton(
          onPressed: () => _changeDate(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final selected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: selected,
              selectedColor: const Color(0xFFD5EEE5),
              onSelected: (_) {
                setState(() => _selectedFilter = filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _summary(List<FoodLogModel> logs) {
    final calories = _total(logs, (log) => log.calories);
    final protein = _total(logs, (log) => log.protein);
    final carbs = _total(logs, (log) => log.carbs);
    final fat = _total(logs, (log) => log.fat);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Nutrition Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${calories.toStringAsFixed(0)} kcal',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              Text('Protein ${protein.toStringAsFixed(1)} g'),
              Text('Carbs ${carbs.toStringAsFixed(1)} g'),
              Text('Fat ${fat.toStringAsFixed(1)} g'),
            ],
          ),
        ],
      ),
    );
  }

  IconData _mealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.wb_twilight;
      case 'Lunch':
        return Icons.wb_sunny_outlined;
      case 'Dinner':
        return Icons.nightlight_round;
      case 'Snack':
        return Icons.apple_outlined;
      default:
        return Icons.restaurant;
    }
  }

  Widget _foodTile(FoodLogModel log) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0F2EC),
          child: Icon(_mealIcon(log.mealType), color: AppColors.primary),
        ),
        title: Text(log.foodName, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${log.grams.toStringAsFixed(0)} g'
          ' · ${log.loggedAt.toLocal().hour.toString().padLeft(2, '0')}:'
          '${log.loggedAt.toLocal().minute.toString().padLeft(2, '0')}',
        ),
        trailing: Text(
          '${log.calories.toStringAsFixed(0)} kcal',
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _listView(List<FoodLogModel> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final mealType in _mealTypes) ...[
          if (logs.any((log) => log.mealType == mealType)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mealType == 'Snack' ? 'Snacks' : mealType,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    '${_total(logs.where((log) => log.mealType == mealType).toList(), (log) => log.calories).toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            for (final log in logs)
              if (log.mealType == mealType) _foodTile(log),
          ],
        ],
      ],
    );
  }

  Widget _timelineView(List<FoodLogModel> logs) {
    final sorted = [...logs]..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    return Column(
      children: [
        for (final log in sorted) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              log.mealType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          _foodTile(log),
        ],
      ],
    );
  }

  Widget _historyContent(List<FoodLogModel> allLogs) {
    final dailyLogs = _logsForDate(allLogs);
    final visibleLogs = _applyFilter(dailyLogs);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              label: Text('List'),
              icon: Icon(Icons.list),
            ),
            ButtonSegment(
              value: true,
              label: Text('Timeline'),
              icon: Icon(Icons.timeline),
            ),
          ],
          selected: {_showTimeline},
          onSelectionChanged: (selection) {
            setState(() => _showTimeline = selection.first);
          },
        ),
        const SizedBox(height: 14),
        _dateSelector(),
        const SizedBox(height: 10),
        _filterChips(),
        const SizedBox(height: 18),
        _summary(dailyLogs),
        const SizedBox(height: 20),

        if (visibleLogs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: Column(
              children: [
                const Icon(
                  Icons.no_meals_outlined,
                  size: 55,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No meals logged for this selection.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, RouteNames.foodScanner);

                    if (!mounted) return;

                    await _refresh();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Log a Meal'),
                ),
              ],
            ),
          )
        else if (_showTimeline)
          _timelineView(visibleLogs)
        else
          _listView(visibleLogs),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      appBar: AppBar(
        title: const Text('Food History'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Select date',
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<FoodLogModel>>(
        future: _logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load food history.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: _historyContent(snapshot.data ?? []),
          );
        },
      ),
    );
  }
}
