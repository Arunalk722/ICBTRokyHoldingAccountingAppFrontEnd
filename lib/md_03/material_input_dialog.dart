import 'package:flutter/material.dart';

class MaterialInputDialog extends StatefulWidget {
  final int itemId;
  final String materialName;

  const MaterialInputDialog({
    super.key,
    required this.itemId,
    required this.materialName,
  });

  @override
  State<MaterialInputDialog> createState() => _MaterialInputDialogState();
}

class _MaterialInputDialogState extends State<MaterialInputDialog> {
  final _qtyController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Material Details - ${widget.materialName}'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = int.tryParse(_qtyController.text) ?? 0;
            final amount = double.tryParse(_amountController.text) ?? 0.0;

            Navigator.pop(context, {
              'itemId': widget.itemId,
              'qty': qty,
              'amount': amount,
              'materialName': widget.materialName,
            });
          },
          child: const Text('Save'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5.0,
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
