import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../env/DialogBoxs.dart';
import '../env/api_info.dart';
import '../env/app_logs_to.dart';
import '../env/print_debug.dart';
import '../env/user_data.dart';

class DisablingOfzRequestDialog extends StatefulWidget {
  final String requestId;
  final String refNumber;

  const DisablingOfzRequestDialog(
      {super.key, required this.requestId, required this.refNumber});

  @override
  DisablingOfzRequestDialogState createState() =>
      DisablingOfzRequestDialogState();
}

class DisablingOfzRequestDialogState extends State<DisablingOfzRequestDialog> {
  late bool confirmToDisable;
  late String requestDetails;
  late TextEditingController _txtComment;
  Future<void> _loadRequestInfo() async {
    try {
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

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        PD.pd(text: responseData.toString());
        if (responseData['status'] == 200) {
          setState(() {
            List<dynamic> requestData = responseData['data'] ?? [];
            var request = requestData.isNotEmpty ? requestData[0] : null;
            if (request != null) {
              requestDetails =
                  request['details']?.toString() ?? "No details available";
              confirmToDisable = request['is_auth'] == '1';
              _txtComment.text = request['cmt'] == 'na' ? '' : request['cmt'];
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
        PD.pd(text: "HTTP Error: ${response.statusCode}");
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'ofz_request_disable.dart');
      PD.pd(text: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    requestDetails = "";
    confirmToDisable = false;
    _txtComment = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequestInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Disable Request ${widget.refNumber}",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(CupertinoIcons.checkmark_seal,
                        color: CupertinoColors.activeGreen),
                    SizedBox(width: 8),
                    Text('Confirm to remove'),
                  ],
                ),
                CupertinoSwitch(
                  value: confirmToDisable,
                  onChanged: (bool value) {
                    setState(() {
                      confirmToDisable = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (confirmToDisable == true) {
              _disableRequest(context, widget.requestId.toString(),
                  confirmToDisable, _txtComment.text);
              Navigator.pop(context);
            } else {}
          },
          isDefaultAction: true,
          child: const Text(
            'Remove',
            style: TextStyle(color: CupertinoColors.activeGreen),
          ),
        ),
      ],
    );
  }

  Future<void> _disableRequest(BuildContext context, String requestId,
      bool confirmToDisable, String comment) async {
    WaitDialog.showWaitDialog(context, message: 'Processing Request');
    try {
      String reqUrl =
          '${APIHost().apiURL}/ofz_payment_controller.php/DisableRequest';
      PD.pd(text: reqUrl);
      final response = await http.post(
        Uri.parse(reqUrl),
        headers: HttpHeader().header,
        body: jsonEncode({
          "idtbl_ofz_request": requestId,
          "change_by": UserCredentials().UserName,
          "cmt": comment,
        }),
      );
      WaitDialog.hideDialog(context);
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 200) {
        OneBtnDialog.oneButtonDialog(
          context,
          title: "Successful",
          message: responseData['message'],
          btnName: 'Ok',
          icon: Icons.verified_outlined,
          iconColor: Colors.black,
          btnColor: Colors.green,
        );
      } else {
        OneBtnDialog.oneButtonDialog(
          context,
          title: 'Error',
          message: responseData['message'] ?? 'Request processing failed',
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
          logFile: 'ofz_request_disable.dart');
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
