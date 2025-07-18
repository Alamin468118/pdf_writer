import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_writer/controller/leave_form_controller.dart';
import 'package:pdf_writer/services/pdf_service.dart';

class LeaveFormView extends StatelessWidget {
  final LeaveFormController controller = Get.put(LeaveFormController());
  final PdfService pdfService = PdfService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Request Form")),
      body: Obx(() {
        final form = controller.form.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _buildTextField("Employee Name", 'employeeName', form.employeeName),
            _buildTextField("Department", 'department', form.department),
            _buildTextField("Manager", 'manager', form.manager),
            _buildDropdown(form.leaveType),
            if (form.leaveType == "Others")
              _buildTextField("Specify Other Leave", 'others', form.others),
            _buildDatePicker(context, "From Date", 'fromDate', form.fromDate),
            _buildDatePicker(context, "To Date", 'toDate', form.toDate),
            _buildTextField("Reason", 'reason', form.reason),
            _buildTextField("Employee Signature", 'employeeSignature', form.employeeSignature),
            _buildDatePicker(context, "Employee Sign Date", 'employeeSignDate', form.employeeSignDate),
            _buildTextField("Manager Signature", 'managerSignature', form.managerSignature),
            _buildDatePicker(context, "Manager Sign Date", 'managerSignDate', form.managerSignDate),
            _buildTextField("Comments", 'comments', form.comments),
            SwitchListTile(
              title: const Text("Approved"),
              value: form.isApproved,
              onChanged: (val) => controller.updateField('isApproved', val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final file = await pdfService.fillLeaveForm(
                    employeeName: form.employeeName,
                    department: form.department,
                    manager: form.manager,
                    leaveType: form.leaveType,
                    others: form.others,
                    fromDate: form.fromDate!,
                    toDate: form.toDate!,
                    reason: form.reason,
                    employeeSignature: form.employeeSignature,
                    employeeSignDate: form.employeeSignDate!,
                    managerSignature: form.managerSignature,
                    managerSignDate: form.managerSignDate!,
                    comments: form.comments,
                    isApproved: form.isApproved,
                  );
                  Get.snackbar("PDF Saved", "Saved to ${file.path}");
                } catch (e) {
                  Get.snackbar("Error", "Failed to generate PDF: $e");
                }
              },
              child: const Text("Export PDF"),
            )
          ]),
        );
      }),
    );
  }

  Widget _buildTextField(String label, String field, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      onChanged: (val) => controller.updateField(field, val),
    );
  }

  Widget _buildDropdown(String selected) {
    return DropdownButtonFormField<String>(
      value: selected.isEmpty ? null : selected,
      decoration: const InputDecoration(labelText: "Leave Type"),
      items: const [
        DropdownMenuItem(value: 'Annual Leave', child: Text("Annual Leave")),
        DropdownMenuItem(value: 'Sick Leave', child: Text("Sick Leave")),
        DropdownMenuItem(value: 'Marriage Leave', child: Text("Marriage Leave")),
        DropdownMenuItem(value: 'Maternity/Paternity Leave', child: Text("Maternity/Paternity Leave")),
        DropdownMenuItem(value: 'Others', child: Text("Others")),
      ],
      onChanged: (val) => controller.updateField('leaveType', val),
    );
  }

  /// ✅ Updated to pass `BuildContext` properly
  Widget _buildDatePicker(BuildContext context, String label, String field, DateTime? value) {
    return ListTile(
      title: Text("$label: ${value != null ? value.toLocal().toString().split(' ')[0] : 'Select'}"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) controller.updateField(field, picked);
      },
    );
  }
}
