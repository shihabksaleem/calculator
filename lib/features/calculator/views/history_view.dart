import 'package:calculator/core/theme/app_theme.dart';
import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:calculator/features/calculator/models/history_item.dart';
import 'package:calculator/features/calculator/views/widgets/entrance_fader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryView extends GetView<CalculatorController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Get.back()),
        title: const Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => controller.clearHistory(),
            child: const Text("Clear", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Search calculations",
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),

          // History List
          Expanded(
            child: Obx(() {
              final items = controller.filteredHistory;
              if (items.isEmpty) {
                return const Center(
                  child: Text("No history found", style: TextStyle(color: Colors.grey)),
                );
              }

              final groupedItems = _groupItemsByDate(items);

              return ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final group = groupedItems[index];
                  if (group is String) {
                    // Date Header
                    return EntranceFader(
                      delay: Duration(milliseconds: index * 50),
                      duration: const Duration(milliseconds: 400),
                      offset: const Offset(0, 10),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          group.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // History Item
                    final item = group as HistoryItem;
                    return EntranceFader(
                      delay: Duration(milliseconds: index * 50),
                      child: _buildHistoryItem(context, item, index),
                    );
                  }
                },
              );
            }),
          ),

          // Footer
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Tap a result to reuse it · Swipe left to delete",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, HistoryItem item, int index) {
    // Find the original index for deletion logic
    final originalIndex = controller.history.indexOf(item);
    final isAlternate = index % 2 == 0;

    return Dismissible(
      key: Key(item.timestamp.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        controller.deleteHistoryItem(originalIndex);
      },
      child: Container(
        color: isAlternate
            ? (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.black.withOpacity(0.03))
            : Colors.transparent,
        child: InkWell(
          onTap: () => controller.reuseHistoryItem(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.equation,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(item.result, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(item.timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _groupItemsByDate(List<HistoryItem> items) {
    List<dynamic> grouped = [];
    String lastDate = "";

    for (var item in items) {
      String dateStr = _getDateHeader(item.timestamp);
      if (dateStr != lastDate) {
        grouped.add(dateStr);
        lastDate = dateStr;
      }
      grouped.add(item);
    }
    return grouped;
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) return "Today";
    if (itemDate == yesterday) return "Yesterday";
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}
