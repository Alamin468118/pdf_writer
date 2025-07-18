import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  Future<File> fillLeaveForm({
    required String employeeName,
    required String department,
    required String manager,
    required String leaveType,
    required String others,
    required DateTime fromDate,
    required DateTime toDate,
    required String reason,
    required String employeeSignature,
    required DateTime employeeSignDate,
    required String managerSignature,
    required DateTime managerSignDate,
    required String comments,
    required bool isApproved,
  }) async {
    final byteData = await rootBundle.load('assets/pdf/Leave_Application_Form.pdf');
    final Uint8List bytes = byteData.buffer.asUint8List();
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final form = document.form;

    void setField(String name, String value) {
  for (int i = 0; i < form.fields.count; i++) {
    final field = form.fields[i];
    if (field.name == name && field is PdfTextBoxField) {
      field.text = value;
      break;
    }
  }
}



    setField("Employee Name", employeeName);
    setField("Department", department);
    setField("Manager/Superior Reporting to", manager);
    setField("Type of Leave", leaveType == 'Others' ? others : leaveType);
    setField("From", fromDate.toIso8601String().split('T')[0]);
    setField("To", toDate.toIso8601String().split('T')[0]);
    setField("Reasons for Absence", reason);
    setField("Employee's Signature", employeeSignature);
    setField("Date", employeeSignDate.toIso8601String().split('T')[0]);
    setField("Manager/Supervsor's Signature", managerSignature);
    setField("Comments", comments);
    setField("Approval", isApproved ? "Approved" : "Rejected");

    final List<int> outputBytes = await document.save();
    document.dispose();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/filled_leave_form.pdf");
    await file.writeAsBytes(outputBytes);

    return file;
  }
}