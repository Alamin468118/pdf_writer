import 'package:get/get.dart';
import 'package:pdf_writer/model/leave_form_model.dart';

class LeaveFormController extends GetxController {
  var form = LeaveFormModel().obs;

  void updateField(String field, dynamic value) {
    form.update((f) {
      switch (field) {
        case 'employeeName':
          f?.employeeName = value;
          break;
        case 'department':
          f?.department = value;
          break;
        case 'manager':
          f?.manager = value;
          break;
        case 'leaveType':
          f?.leaveType = value;
          break;
        case 'others':
          f?.others = value;
          break;
        case 'fromDate':
          f?.fromDate = value;
          break;
        case 'toDate':
          f?.toDate = value;
          break;
        case 'reason':
          f?.reason = value;
          break;
        case 'employeeSignature':
          f?.employeeSignature = value;
          break;
        case 'employeeSignDate':
          f?.employeeSignDate = value;
          break;
        case 'managerSignature':
          f?.managerSignature = value;
          break;
        case 'managerSignDate':
          f?.managerSignDate = value;
          break;
        case 'comments':
          f?.comments = value;
          break;
        case 'isApproved':
          f?.isApproved = value;
          break;
      }
    });
  }
}