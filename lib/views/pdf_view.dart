import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_writer/controller/pdf_controller.dart';
import 'package:printing/printing.dart';

class PdfView extends StatelessWidget {
  final PdfController ctrl = Get.put(PdfController());
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView(
                    children: ctrl.items
                        .map((item) => ListTile(
                              title: Text(item.desc),
                              subtitle: Text(
                                  'Quantity: ${item.qty}, Price: RM ${item.rate.toStringAsFixed(2)}'),
                              trailing: Text('Total: RM ${item.total.toStringAsFixed(2)}'),
                            ))
                        .toList(),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                Printing.layoutPdf(onLayout: (_) => ctrl.generatePdf());
              },
              child: const Text('Preview PDF'),
            ),
            ElevatedButton(
              onPressed: ctrl.sharePdf,
              child: const Text('Share PDF'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (emailCtrl.text.isNotEmpty) {
                      ctrl.emailPdf(emailCtrl.text);
                    } else {
                      Get.snackbar('Missing', 'Please enter an email');
                    }
                  },
                  child: const Text('Email PDF'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}