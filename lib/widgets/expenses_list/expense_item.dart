import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  "\$${expense.amount.toStringAsFixed(2)}",
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.alarm),
                    SizedBox(width: 8),
                    Text(
                      expense.date.toString(),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
