import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:caspen/pages/category_page_ori.dart';
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
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
        print("selected date: $selectedDate");
      }
      currentIndex = index;
      _pages = [HomePage(selectedDate: selectedDate), CategoryPage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          (currentIndex == 0)
              ? CalendarAppBar(
                accent: Colors.blue,
                backButton: false,
                locale: 'in_ID',

                onDateChanged: (value) {
                  setState(() {
                    selectedDate = value;
                  });
                  selectedDate = value;
                  updateView(0, selectedDate);
                },
                firstDate: DateTime.now().subtract(Duration(days: 140)),
                lastDate: DateTime.now(),
              )
              : PreferredSize(
                preferredSize: Size.fromHeight(100.0),
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
        visible: (currentIndex == 0) ? true : false,
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
          child: Icon(Icons.add),
        ),
      ),
      body: _pages[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home),
            ),
            SizedBox(width: 20),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.apps),
            ),
          ],
        ),
      ),
    );
  }
}
