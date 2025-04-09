import 'package:caspen/models/database.dart';
import 'package:caspen/models/transaction_with_category.dart';
import 'package:caspen/pages/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({super.key, required this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late AppDb db;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = Provider.of<AppDb>(context);
  }

  bool isExpense = true;
  late int type = 2; // 1 = income, 2 = expense

  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController datailController = TextEditingController();
  Category? selectedCategory;

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
      dateController.text = ""; //tambahan dari uangkoo
    }
    super.initState();
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await db.getAllCategoryRepo(type);
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    dateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(transactionWithCategory.transaction.transactiondate);
    datailController.text = transactionWithCategory.transaction.name;
    selectedCategory = transactionWithCategory.category;
    isExpense = (transactionWithCategory.category.type == 2) ? true : false;
    type = (isExpense) ? 2 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Switch(
                    value: isExpense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpense = value;
                        type = (isExpense) ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  Text(
                    isExpense ? "Expense" : "Income",
                    style: GoogleFonts.montserrat(fontSize: (14)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Amount",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Category",
                  style: GoogleFonts.montserrat(fontSize: (14)),
                ),
              ),
              FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        print('APAINIH:$snapshot');
                        selectedCategory =
                            (selectedCategory == null)
                                ? snapshot.data!.first
                                : selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<Category>(
                            value:
                                (selectedCategory == null)
                                    ? snapshot.data!.first
                                    : selectedCategory,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            items:
                                snapshot.data!.map((Category item) {
                                  return DropdownMenuItem<Category>(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),

                            onChanged: (Category? value) {
                              setState(() {
                                print('SELECTED CATEGORY: ${value!.name}');
                                selectedCategory = value;
                              });
                            },
                          ),
                        );
                      } else {
                        return Center(child: Text("No Data Found"));
                      }
                    } else {
                      return Center(child: Text("No Data Found"));
                    }
                  }
                },
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Enter Date"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: datailController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Detail",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Simpan context saat ini ke dalam variabel lokal
                    final currentContext = context;

                    // Validasi input
                    if (amountController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        datailController.text.isEmpty ||
                        selectedCategory == null) {
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    // Operasi asinkron
                    if (widget.transactionWithCategory == null) {
                      print('Insert transaction');
                      Provider.of<TransactionProvider>(
                        context,
                        listen: false,
                      ).insertTransaction(
                        int.parse(amountController.text),
                        DateTime.parse(dateController.text),
                        datailController.text,
                        selectedCategory!.id,
                      );
                    } else {
                      Provider.of<TransactionProvider>(
                        context,
                        listen: false,
                      ).updateTransaction(
                        amount: int.parse(amountController.text),
                        transactionDate: DateTime.parse(dateController.text),
                        nameDetail: datailController.text,
                        id: widget.transactionWithCategory!.transaction.id,
                        categoryId: selectedCategory!.id,
                      );
                    }

                    // Pastikan 'mounted' sebelum menggunakan 'Navigator.pop'
                    if (mounted) {
                      Navigator.pop(currentContext, true);
                    }
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
