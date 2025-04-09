import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:caspen/pages/category_page.dart';
import 'package:caspen/pages/home_page.dart';
import 'package:caspen/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _pages;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    updateView(0, DateTime.now());
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
        print("selected date: $selectedDate");
      }
      currentIndex = index;
      _pages = [HomePage(selectedDate: selectedDate), const CategoryPage()];
    });
  }

  Widget _buildBottomItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => updateView(index, index == 0 ? DateTime.now() : null),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          (currentIndex == 0)
              ? CalendarAppBar(
                accent: Colors.blue,
                backButton: false,
                locale: 'in_ID',
                onDateChanged: (value) {
                  selectedDate = value;
                  updateView(0, selectedDate);
                },
                firstDate: DateTime.now().subtract(const Duration(days: 140)),
                lastDate: DateTime.now(),
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
      floatingActionButton: Visibility(
        visible: currentIndex == 0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            TransactionPage(transactionWithCategory: null),
                  ),
                )
                .then((value) {
                  setState(() {});
                });
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(child: _pages[currentIndex]),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomItem(Icons.home, 'Home', 0),
                _buildBottomItem(Icons.apps, 'Kategori', 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
