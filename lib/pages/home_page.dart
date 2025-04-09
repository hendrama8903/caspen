import 'package:caspen/models/database.dart';
import 'package:caspen/models/transaction_with_category.dart';
import 'package:caspen/pages/transaction_page.dart';
import 'package:caspen/pages/transaction_provider.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;

  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final AppDb db = AppDb();
  late AppDb db;
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = Provider.of<AppDb>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income & Expense Header
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Income Section
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.download,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<int>(
                            stream: db.watchTotalAmountByMonthRepo(
                              1,
                              widget.selectedDate,
                            ),
                            builder: (context, snapshot) {
                              final total = snapshot.data ?? 0;
                              return Text(
                                currencyFormatter.format(total),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Expense Section
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.upload, size: 50, color: Colors.red),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),

                          StreamBuilder<int>(
                            stream: db.watchTotalAmountByMonthRepo(
                              2,
                              widget.selectedDate,
                            ),
                            builder: (context, snapshot) {
                              final total = snapshot.data ?? 0;
                              return Text(
                                currencyFormatter.format(total),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Transaction Overview",
          //         style: GoogleFonts.montserrat(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 16),
          //       SizedBox(
          //         height: 200,
          //         child: PieChart(
          //           PieChartData(
          //             sections: [
          //               PieChartSectionData(
          //                 color: Colors.green,
          //                 value: 4000000,
          //                 title: 'Income',
          //                 radius: 60,
          //                 titleStyle: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 14,
          //                 ),
          //               ),
          //               PieChartSectionData(
          //                 color: Colors.red,
          //                 value: 2500000,
          //                 title: 'Expense',
          //                 radius: 60,
          //                 titleStyle: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 14,
          //                 ),
          //               ),
          //             ],
          //             sectionsSpace: 2,
          //             centerSpaceRadius: 30,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ), // section pie chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Transcation",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TransactionWithCategory>>(
              stream: db.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final transaction = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                transaction.category.type == 2
                                    ? Icons.upload
                                    : Icons.download,
                                color:
                                    transaction.category.type == 2
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            ),
                            title: Text(
                              currencyFormatter.format(
                                transaction.transaction.amount,
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              "${transaction.category.name}(${transaction.transaction.name})",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 27,
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text(
                                            "Delete transaction '${snapshot.data![index].transaction.amount}'?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                Provider.of<
                                                  TransactionProvider
                                                >(
                                                  context,
                                                  listen: false,
                                                ).deleteTransaction(
                                                  snapshot
                                                      .data![index]
                                                      .transaction
                                                      .id,
                                                );
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Transaction deleted",
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => TransactionPage(
                                              transactionWithCategory:
                                                  snapshot.data![index],
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No Transaction"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
