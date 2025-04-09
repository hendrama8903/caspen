import 'package:caspen/models/database.dart';
import 'package:caspen/models/transaction_with_category.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  final AppDb db;
  TransactionProvider(this.db);

  List<TransactionWithCategory> _transactions = [];
  List<TransactionWithCategory> get transactions => _transactions;

  bool isExpense = true;
  int get type => isExpense ? 2 : 1;

  void switchType(bool value) {
    isExpense = value;
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _transactions = await db.getAllTransactionWithCategoryRepo(type);
    notifyListeners();
  }

  Stream<List<TransactionWithCategory>> getTransactionByDate(DateTime date) {
    return db.getTransactionByDateRepo(date);
  }

  Future<void> updateTransaction({
    required int id,
    required int amount,
    required int categoryId,
    required DateTime transactionDate,
    required String nameDetail,
  }) async {
    await db.updateTransactionRepo(
      id,
      amount,
      categoryId,
      transactionDate,
      nameDetail,
    );
    await loadTransactions(); // Jika pakai snapshot, ini bisa di-skip
  }

  Future<void> insertTransaction(
    int amount,
    DateTime date,
    String nameDetail,
    int categoryId,
  ) async {
    final now = DateTime.now();
    await db
        .into(db.transactions)
        .insertReturning(
          TransactionsCompanion.insert(
            name: nameDetail,
            categoryid: categoryId,
            transactiondate: date,
            amount: amount,
            createdAt: now,
            updatedAt: now,
          ),
        );
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    await db.deleteTransactionRepo(id);
    await loadTransactions();
  }

  // Future<int> getTotalAmountByType(int type) async {
  //   return await db.getTotalAmountByTypeRepo(type);
  // }

  Stream<Transaction> getTotalAmountStreamByType(int type) {
    return db.watchTotalAmountByType(type);
  }
}
