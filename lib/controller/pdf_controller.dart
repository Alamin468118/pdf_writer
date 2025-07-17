import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_writer/model/item_model.dart';
import 'package:pdf_writer/model/user_model.dart';
import 'package:share_plus/share_plus.dart';

class PdfController extends GetxController {
  final user = UserModel(name: 'John Doe', email: 'john@example.com');
  final items = <ItemModel>[
    ItemModel(desc: "Apple", qty: 3, rate: 2.5),
    ItemModel(desc: "Orange", qty: 5, rate: 1.75),
    ItemModel(desc: "Banana", qty: 2, rate: 1.2),
  ].obs;

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    final logoBytes = await rootBundle.load('assets/icon.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(logoImage, height: 80)),
              pw.Center(
      child: pw.Container(
        width: 80,
        height: 80,
        decoration: pw.BoxDecoration(
          color: PdfColors.blueGrey,
          shape: pw.BoxShape.circle,
        ),
        alignment: pw.Alignment.center,
        child: pw.Text(
          'YA',
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    ),
              pw.SizedBox(height: 20),
              pw.Text('Sales Invoice', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Text('Generated with Flutter + GetX'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Price', 'Total'],
                data: items.map((i) => [
                  i.desc,
                  i.qty.toString(),
                  i.rate.toStringAsFixed(2),
                  i.total.toStringAsFixed(2),
                ]).toList(),
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Grand Total: RM ${items.map((i) => i.total).reduce((a, b) => a + b).toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<String> savePdfToFile(Uint8List data) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice.pdf');
    await file.writeAsBytes(data);
    return file.path;
  }

  Future<void> sharePdf() async {
    final data = await generatePdf();
    final path = await savePdfToFile(data);
    await Share.shareXFiles([XFile(path)], text: "Here's your invoice PDF.");
  }

  Future<void> emailPdf(String recipient) async {
    final data = await generatePdf();
    final path = await savePdfToFile(data);
    final email = Email(
      body: 'Attached is your invoice.',
      subject: 'Invoice',
      recipients: [recipient],
      attachmentPaths: [path],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }
}