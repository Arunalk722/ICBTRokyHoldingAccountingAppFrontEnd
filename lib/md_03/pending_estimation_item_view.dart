import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roky_holding/env/DialogBoxs.dart';
import 'package:roky_holding/env/app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:roky_holding/env/number_format.dart';
import 'package:roky_holding/env/print_debug.dart';
import '../env/api_info.dart';
import '../env/app_logs_to.dart';
import '../env/user_data.dart';

class PendingEstimationItemView extends StatefulWidget {
  final String locationId;
  final String estimationId;
  final String projectId;
  final String estimationReqId;
  const PendingEstimationItemView(
      {super.key,
      required this.locationId,
      required this.estimationId,
      required this.projectId,
      required this.estimationReqId});

  @override
  State<PendingEstimationItemView> createState() =>
      _PendingEstimationItemViewState();
}

class _PendingEstimationItemViewState extends State<PendingEstimationItemView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ProjectLocationEstimationListItem> _requestedItems = [];

  bool _isLoading = true;
  String _errorMessage = '';
  bool isNotToApprove = true;
  bool isApproved = false;
  bool canDelete = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataRequestMateriaList();
    });
  }

  Future<void> getDataRequestMateriaList() async {
    String apiURL =
        '${APIHost().apiURL}/estimation_controller.php/EstimationItemView';
    PD.pd(text: apiURL);
    try {
      WaitDialog.showWaitDialog(context, message: 'loading material list');
      final response = await http.post(
        Uri.parse(apiURL),
        headers: HttpHeader().header,
        body: jsonEncode({
          'estimation_req_id': widget.estimationReqId,
          'project_id': widget.projectId,
          'location_id': widget.locationId,
          'estimation_id': widget.estimationId
        }),
      );
      if (response.statusCode == 200) {
        WaitDialog.hideDialog(context);
        final responseData = jsonDecode(response.body);
        PD.pd(text: responseData.toString());
        if (responseData['status'] == 200) {
          List<dynamic> data = responseData['data'];
          setState(() {
            _requestedItems = data
                .map((json) => ProjectLocationEstimationListItem.fromJson(json))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Error loading requests';
            _isLoading = false;
          });
        }
      } else {
        WaitDialog.hideDialog(context);
        setState(() {
          _errorMessage = 'HTTP Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'pending_estimation_item_view.dart');
      WaitDialog.hideDialog(context);
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      PD.pd(text: e.toString());
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    String apiURL =
        '${APIHost().apiURL}/project_payment_controller.php/ImageDeleteFromUrl';
    PD.pd(text: apiURL);
    try {
      WaitDialog.showWaitDialog(context, message: 'loading material list');
      final response = await http.delete(
        Uri.parse(apiURL),
        headers: HttpHeader().header,
        body: jsonEncode({'image_url': imageUrl}),
      );
      if (response.statusCode == 200) {
        WaitDialog.hideDialog(context);
        final responseData = jsonDecode(response.body);
        PD.pd(text: responseData.toString());
        if (responseData['status'] == 200) {
          OneBtnDialog.oneButtonDialog(context,
              title: 'Image Removed',
              message: responseData['message'],
              btnName: 'Ok',
              icon: Icons.verified,
              iconColor: Colors.green,
              btnColor: Colors.black);
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Error loading requests';
            _isLoading = false;
          });
        }
      } else {
        WaitDialog.hideDialog(context);
        setState(() {
          _errorMessage = 'HTTP Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'pending_estimation_item_view.dart');
      WaitDialog.hideDialog(context);
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      PD.pd(text: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(appname: 'Project Estimation Items'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[50]!, Colors.grey[100]!],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildEstimationTable(_requestedItems),
                    ),
                  ),
                ),
    );
  }

  Widget _buildEstimationTable(List<ProjectLocationEstimationListItem> items) {
    final totalValue = items.fold(
      0.0,
      (sum, item) => sum + (item.estimateQty * item.estimateAmount),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Total Items",
                      value: items.length.toString(),
                      icon: Icons.list,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      title: "Total Value",
                      value:
                          "Rs. ${NumberStyles.currencyStyle(totalValue.toStringAsFixed(2))}",
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 12,
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => Colors.blue.shade50,
                      ),
                      columns: [
                        DataColumn(label: _buildTableHeader('Project')),
                        DataColumn(label: _buildTableHeader('Location')),
                        DataColumn(label: _buildTableHeader('Work Type')),
                        DataColumn(label: _buildTableHeader('Category')),
                        DataColumn(label: _buildTableHeader('Material')),
                        DataColumn(
                            label: _buildTableHeader('Qty'), numeric: true),
                        DataColumn(
                            label: _buildTableHeader('Unit Price'),
                            numeric: true),
                        DataColumn(
                            label: _buildTableHeader('Total'), numeric: true),
                        DataColumn(label: _buildTableHeader('Status')),
                        DataColumn(label: _buildTableHeader('Actions')),
                      ],
                      rows: items.map((item) {
                        final total = item.estimateQty * item.estimateAmount;
                        return DataRow(
                          cells: [
                            _buildDataCell(item.projectName),
                            _buildDataCell(item.locationName),
                            _buildDataCell(item.workName),
                            _buildDataCell(item.costCategory),
                            _buildDataCell(item.materialName),
                            _buildDataCell(item.estimateQty.toStringAsFixed(2)),
                            _buildDataCell(NumberStyles.currencyStyle(
                                item.estimateAmount.toStringAsFixed(2))),
                            _buildDataCell(NumberStyles.currencyStyle(
                                total.toStringAsFixed(2))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.estimationReqId > 0
                                      ? Colors.orange[100]
                                      : Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.estimationReqId > 0
                                      ? 'Locked'
                                      : 'Active',
                                  style: TextStyle(
                                    color: item.estimationReqId > 0
                                        ? Colors.orange[800]
                                        : Colors.green[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.estimationReqId > 0
                                      ? Colors.orange[100]
                                      : Colors.green[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      YNDialogCon.ynDialogMessage(
                                        context,
                                        messageBody:
                                            'Confirm to remove item from estimation',
                                        messageTitle: 'Remove item',
                                        icon: Icons.verified_outlined,
                                        iconColor: Colors.black,
                                        btnDone: 'YES',
                                        btnClose: 'NO',
                                      ).then((value) async {
                                        if (value == 1) {
                                          await _deleteItem((int.tryParse(item
                                                      .estimationListId
                                                      .toString()) ??
                                                  0) ??
                                              0);
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.delete_outline)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  DataCell _buildDataCell(String text) {
    return DataCell(
      Container(
        constraints: const BoxConstraints(maxWidth: 150),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildInfoList(
      List<ProjectLocationEstimationListItem> items, double screenWidth) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final request = items[index];
        final double total = request.estimateQty * request.estimateAmount;

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Work Type: ${request.workName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Project: ${request.projectName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Location: ${request.locationName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Category: ${request.costCategory}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Material: ${request.materialName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Description: ${request.materialDescription}",
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "Qty: ${request.estimateQty}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Unit Amount: Rs. ${request.estimateAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Estimation Value:",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    Text(
                      "Rs. ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteItem(int id) async {
    try {
      WaitDialog.showWaitDialog(context, message: 'Loading');

      String reqUrl =
          '${APIHost().apiURL}/estimation_controller.php/DeleteItems';
      PD.pd(text: reqUrl);
      final response = await http.post(
        Uri.parse(reqUrl),
        headers: HttpHeader().header,
        body: jsonEncode({
          "idtbl_project_location_estimations_list": id,
        }),
      );

      if (response.statusCode == 200) {
        WaitDialog.hideDialog(context);
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        PD.pd(text: responseData.toString());
        if (responseData['status'] == 200) {
          OneBtnDialog.oneButtonDialog(
            context,
            title: 'Successful',
            message: responseData['message'],
            btnName: 'OK',
            icon: Icons.notification_add,
            iconColor: Colors.green,
            btnColor: Colors.black,
          ).then((value) async {
            if (value == true) {
              getDataRequestMateriaList();
            }
          });
        } else {
          throw Exception(
              responseData['message'] ?? 'Error deleting estimations');
        }
      } else {
        WaitDialog.hideDialog(context);
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'pending_estimation_item_view.dart');
      WaitDialog.hideDialog(context);
      PD.pd(text: e.toString());
      OneBtnDialog.oneButtonDialog(
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

  Future<void> removeRequestItem(
      BuildContext context, int id, String name, int requestId) async {
    try {
      WaitDialog.showWaitDialog(context, message: 'Processing Request...');
      String apiURL =
          '${APIHost().apiURL}/project_payment_controller.php/DeleteBilledItem';
      PD.pd(text: apiURL);
      final response = await http.post(
        Uri.parse(apiURL),
        headers: HttpHeader().header,
        body: jsonEncode({
          "request_id": requestId,
          "idtbl_user_request_list": id,
          "isLog": 1,
          "BilledName": name,
          "created_by": UserCredentials().UserName
        }),
      );

      WaitDialog.hideDialog(context);
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (responseData['status'] == 200) {
            OneBtnDialog.oneButtonDialog(
              context,
              title: "Successful",
              message: responseData['message'],
              btnName: 'Ok',
              icon: Icons.verified_outlined,
              iconColor: Colors.black,
              btnColor: Colors.green,
            ).then((value) {
              PD.pd(text: value.toString());
              if (value == true) {
                getDataRequestMateriaList();
              }
            });
          } else {
            showErrorDialog(context, responseData['message'] ?? 'Error');
          }
        } catch (e, st) {
          ExceptionLogger.logToError(
              message: e.toString(),
              errorLog: st.toString(),
              logFile: 'pending_estimation_item_view.dart');
          showErrorDialog(context, "Error decoding JSON response.");
        }
      } else {
        handleHttpError(context, response);
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'pending_estimation_item_view.dart');
      handleGeneralError(context, e);
    }
  }

  Future<void> changePriceAndQty(
      BuildContext context,
      int id,
      int requestId,
      String billedName,
      String reqQty,
      String reqAmount,
      String oldPrice,
      String oldQty,
      int materialId,
      String oldTotal,
      String newTotal,
      String newDisc) async {
    try {
      WaitDialog.showWaitDialog(context, message: 'Change Price...');

      final response = await http.post(
        Uri.parse(
            '${APIHost().apiURL}/project_payment_controller.php/EditPriceAndQty'),
        headers: HttpHeader().header,
        body: jsonEncode({
          "request_id": requestId,
          "idtbl_user_request_list": id,
          "material_name": billedName,
          "req_qty": reqQty.toString().replaceAll(',', ''),
          "req_amout": reqAmount.toString().replaceAll(',', ''),
          "old_price": oldPrice.toString().replaceAll(',', ''),
          "old_qty": oldQty.toString().replaceAll(',', ''),
          "old_total": oldTotal.toString().replaceAll(',', ''),
          "new_total": newTotal.toString().replaceAll(',', ''),
          "material_id": materialId.toString().replaceAll(',', ''),
          "item_disc": newDisc.toString().replaceAll(',', ''),
          "created_by": UserCredentials().UserName
        }),
      );

      WaitDialog.hideDialog(context);
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          PD.pd(text: responseData.toString());
          if (responseData['status'] == 200) {
            OneBtnDialog.oneButtonDialog(
              context,
              title: "Successful",
              message: responseData['message'],
              btnName: 'Ok',
              icon: Icons.verified_outlined,
              iconColor: Colors.black,
              btnColor: Colors.green,
            );
            getDataRequestMateriaList();
          } else {
            showErrorDialog(context, responseData['message'] ?? 'Error');
          }
        } catch (e, st) {
          ExceptionLogger.logToError(
              message: e.toString(),
              errorLog: st.toString(),
              logFile: 'pending_estimation_item_view.dart');
          showErrorDialog(context, "Error decoding JSON response.");
        }
      } else {
        handleHttpError(context, response);
      }
    } catch (e, st) {
      ExceptionLogger.logToError(
          message: e.toString(),
          errorLog: st.toString(),
          logFile: 'pending_estimation_item_view.dart');
      handleGeneralError(context, e);
    }
  }
}

void handleHttpError(BuildContext context, http.Response response) {
  String errorMessage =
      'Request failed with status code ${response.statusCode}';
  try {
    final errorData = jsonDecode(response.body);
    errorMessage = errorData['message'] ?? errorMessage;
  } catch (e, st) {
    ExceptionLogger.logToError(
        message: e.toString(),
        errorLog: st.toString(),
        logFile: 'pending_estimation_item_view.dart');
  }
  showErrorDialog(context, errorMessage);
}

void handleGeneralError(BuildContext context, dynamic e) {
  String errorMessage = (e is SocketException)
      ? 'Network error. Please check your connection.'
      : 'An error occurred: $e';
  showErrorDialog(context, errorMessage);
}

void showErrorDialog(BuildContext context, String message) {
  ExceptionDialog.exceptionDialog(
    context,
    title: 'Error',
    message: message,
    btnName: 'OK',
    icon: Icons.error,
    iconColor: Colors.red,
    btnColor: Colors.black,
  );
}

class ProjectLocationEstimationListItem {
  final int estimationId;
  final int estimationListId;
  final String projectName;
  final String locationName;
  final String workName;
  final String costCategory;
  final String materialName;
  final String materialDescription;
  final double estimateQty;
  final double estimateAmount;
  final int estimationReqId;

  ProjectLocationEstimationListItem({
    required this.estimationId,
    required this.estimationListId,
    required this.projectName,
    required this.locationName,
    required this.workName,
    required this.costCategory,
    required this.materialName,
    required this.materialDescription,
    required this.estimateQty,
    required this.estimateAmount,
    required this.estimationReqId,
  });

  factory ProjectLocationEstimationListItem.fromJson(
      Map<String, dynamic> json) {
    return ProjectLocationEstimationListItem(
      estimationReqId: json['estimation_req_id'],
      costCategory: json['material_name'],
      estimateAmount: double.tryParse(json['estimate_amount']) ?? 0,
      estimateQty: double.tryParse(json['estimate_qty']) ?? 0,
      estimationId: json['estimation_id'],
      estimationListId: json['idtbl_project_location_estimations_list'],
      locationName: json['location_name'],
      materialDescription: json['material_description'],
      materialName: json['material_name'],
      projectName: json['project_name'],
      workName: json['work_name'],
    );
  }
}
