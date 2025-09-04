import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../env/DialogBoxs.dart';
import '../env/api_info.dart';
import '../env/app_logs_to.dart';
import '../env/print_debug.dart';
import '../env/user_data.dart';

class ApproveOfzRequestDialog extends StatefulWidget {
  final int requestId;
  final String refNumber;
  const ApproveOfzRequestDialog({
    super.key,
    required this.refNumber,
    required this.requestId,
  });

  @override
  ApproveOfzRequestDialogState createState() => ApproveOfzRequestDialogState();
}

class ApproveOfzRequestDialogState extends State<ApproveOfzRequestDialog> {
  late bool isApproved;
  late String requestDetails;
  late String refNumber = '';
  late TextEditingController _txtComment;
  Future<void> _loadRequestInfo() async {
    try {
      WaitDialog.showWaitDialog(context, message: 'loading');
      String apiURL =
          '${APIHost().apiURL}/ofz_payment_controller.php/ListOfRequestById';
      PD.pd(text: apiURL);
      final response = await http.post(
        Uri.parse(apiURL),
        headers: HttpHeader().header,
        body: jsonEncode({
          'idtbl_ofz_request': widget.requestId,
          "req_ref_number": widget.refNumber,
        }),
      );
      PD.pd(text: apiURL);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        final responseData = jsonDecode(response.body);
        PD.pd(text: responseData.toString());
        if (responseData['status'] == 200) {
          setState(() {
            List<dynamic> requestData = responseData['data'] ?? [];
            var request = requestData.isNotEmpty ? requestData[0] : null;
            if (request != null) {
              refNumber = request['req_ref_number'];
              isApproved = request['is_appro'] == 1;
              _txtComment.text =
                  request['appro_cmt'] == 'na' ? '' : request['appro_cmt'];
            }
          });
        } else {
          final String message = responseData['message'] ?? 'Error';
          OneBtnDialog.oneButtonDialog(
            context,
            title: 'Error',
            message: message,
            btnName: 'OK',
            icon: Icons.error,
            iconColor: Colors.red,
            btnColor: Colors.black,
          );
        }
      } else {
        Navigator.pop(context);
        PD.pd(text: "HTTP Error: ${response.statusCode}");
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'view_user_own_request_list.dart');
      Navigator.pop(context);
      PD.pd(text: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    requestDetails = "";
    isApproved = false;
    _txtComment = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequestInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Approve Request",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField(
              controller: _txtComment,
              placeholder: 'Enter your comment here',
              maxLines: 3,
              padding: EdgeInsets.all(8.0),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () async {
            final val = await YNDialogCon.ynDialogMessage(
              context,
              messageBody:
                  'Are you sure you want to Reject Approving request number $refNumber?',
              messageTitle: 'Confirm Payment',
              icon: Icons.verified,
              iconColor: Colors.green,
              btnDone: 'Reject',
              btnClose: 'Cancel',
            );
            if (val == 1) {
              approveOrRejectRequest(
                  context, widget.requestId, -1, _txtComment.text);
            }
          },
          child: const Text(
            'Reject',
            style: TextStyle(color: CupertinoColors.systemRed),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () async {
            final val = await YNDialogCon.ynDialogMessage(
              context,
              messageBody:
                  'Are you sure you want to Approve request number $refNumber?',
              messageTitle: 'Confirm Payment',
              icon: Icons.verified,
              iconColor: Colors.green,
              btnDone: 'Approve',
              btnClose: 'Cancel',
            );
            if (val == 1) {
              approveOrRejectRequest(
                  context, widget.requestId, 1, _txtComment.text);
            }
          },
          isDefaultAction: true,
          child: const Text(
            'Approved',
            style: TextStyle(color: CupertinoColors.activeGreen),
          ),
        ),
      ],
    );
  }

  Future<void> approveOrRejectRequest(BuildContext context, int requestId,
      int isApproved, String comment) async {
    WaitDialog.showWaitDialog(context, message: 'Processing Request');
    try {
      String apiURL = '${APIHost().apiURL}/ofz_payment_controller.php/Approve';
      PD.pd(text: apiURL);
      final response = await http.post(
        Uri.parse(apiURL),
        headers: HttpHeader().header,
        body: jsonEncode({
          "idtbl_ofz_request": requestId,
          "is_appro": isApproved,
          "appro_user": UserCredentials().UserName,
          "appro_cmt": comment,
        }),
      );
      WaitDialog.hideDialog(context);
      final responseData = jsonDecode(response.body);
      PD.pd(text: responseData.toString());
      if (response.statusCode == 200 && responseData['status'] == 200) {
        OneBtnDialog.oneButtonDialog(
          context,
          title: "Successful",
          message: '${responseData['message']} $refNumber',
          btnName: 'Ok',
          icon: Icons.verified_outlined,
          iconColor: Colors.black,
          btnColor: Colors.green,
        ).then((value) {
          if (value == true) {
            Navigator.pop(context, true);
          }
        });
      } else {
        OneBtnDialog.oneButtonDialog(
          context,
          title: 'Error',
          message: '${responseData['message']} $refNumber',
          btnName: 'OK',
          icon: Icons.error,
          iconColor: Colors.red,
          btnColor: Colors.black,
        );
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'view_user_own_request_list.dart');
      WaitDialog.hideDialog(context);
      ExceptionDialog.exceptionDialog(
        context,
        title: 'Error',
        message: e.toString(),
        btnName: 'OK',
        icon: Icons.error,
        iconColor: Colors.red,
        btnColor: Colors.black,
      );
    }
  }
}
