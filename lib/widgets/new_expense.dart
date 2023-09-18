import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final Function(Expense expense) onAddExpense;
  const NewExpense({super.key, required this.onAddExpense});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  Expense? newExpense;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final amountEntered = double.tryParse(_amountController.text.trim());
    final amountIsInvalid = amountEntered == null || amountEntered <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Text"),
          content: const Text("Title, Amount or Date is Invalid"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Okay",
              ),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      newExpense = Expense(
        title: _titleController.text,
        amount: amountEntered,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: ((context, constraints) {
        final width = constraints.maxWidth;

        Widget titleWidget = TextField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(
            label: Text(
              "Title",
            ),
          ),
        );

        Widget amountWidget = TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefix: Text("\$"),
            label: Text(" Amount"),
          ),
        );

        Widget categoryWidget = DropdownButton(
          value: _selectedCategory,
          items: Category.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedCategory = value;
            });
          },
        );

        Widget dateWidget = Row(
          children: [
            Text(
              _selectedDate == null
                  ? "No Date Selected"
                  : formatter.format(_selectedDate!),
            ),
            IconButton(
              onPressed: _presentDatePicker,
              icon: const Icon(
                Icons.calendar_month,
              ),
            ),
          ],
        );

        var cancelButton = TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        );
        var saveButton = ElevatedButton(
          onPressed: _submitExpenseData,
          child: const Text("Save Expense"),
        );
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardHeight + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: titleWidget),
                        const SizedBox(width: 24),
                        Expanded(child: amountWidget),
                      ],
                    )
                  else
                    titleWidget,
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        categoryWidget,
                        dateWidget,
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: amountWidget,
                        ),
                        const Spacer(),
                        dateWidget,
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        cancelButton,
                        saveButton,
                      ],
                    )
                  else
                    Row(
                      children: [
                        categoryWidget,
                        const Spacer(),
                        cancelButton,
                        saveButton,
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
