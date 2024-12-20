import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

// Model for Transaction data
class Transaction {
  final String kode;
  final String customerName;
  final String employeeName;
  final String amount;
  final String date;
  final String paymentMethod;
  final String status;

  Transaction({
    required this.kode,
    required this.customerName,
    required this.employeeName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.status,
  });

  // Converts JSON data into a Transaction object
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      kode: json['kode'],
      customerName: json['customer']['name'],
      employeeName: json['employee']['name'],
      amount: json['amount'],
      date: json['date'],
      paymentMethod: json['payment_method'],
      status: json['status'],
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Transaction> transactions = []; // List to store transaction data
  bool isLoading = true;  // For showing loading indicator
  String? errorMessage;   // For displaying error message in case of failure

  // Fetching transaction data from API
  Future<void> fetchTransactions() async {
    final response = await http.get(Uri.parse('https://petcare.mahasiswarandom.my.id/api/data-transactions'));

    if (response.statusCode == 200) {
      // Parse JSON data into list of transactions
      final List<dynamic> data = json.decode(response.body)['transactions'];
      setState(() {
        transactions = data.map((item) => Transaction.fromJson(item)).toList();
        isLoading = false;  // Data fetched successfully, hide loading indicator
      });
    } else {
      setState(() {
        isLoading = false;  // Hide loading indicator on failure
        errorMessage = 'Failed to load transactions. Please try again later.';
      });
    }
  }

  // Function to download and open the PDF
  Future<void> downloadAndOpenPdf(String transactionId) async {
    try {
      // Construct the API URL for exporting the transaction
      final url = Uri.parse('https://petcare.mahasiswarandom.my.id/api/export-transactions/$transactionId');
      print("Requesting PDF from URL: $url");  // Debugging the URL

      // Make the HTTP request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the response is successful, save the PDF file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/receipt_$transactionId.pdf';
        final file = File(filePath);

        // Write the PDF data to the file
        await file.writeAsBytes(response.bodyBytes);

        // Open the PDF file
        OpenFile.open(filePath);
      } else if (response.statusCode == 404) {
        // Handle 404 errors (not found)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Transaction not found. Please check the transaction ID.'),
        ));
      } else {
        // Handle other errors
        throw Exception('Failed to download PDF, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      // General error handling
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTransactions(); // Fetch transactions when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Notifications'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching data
          : errorMessage != null
              ? Center(child: Text(errorMessage!))  // Show error message if data fetching fails
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Transaction Code: ${transaction.kode}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${transaction.customerName}'),
                            Text('Employee: ${transaction.employeeName}'),
                            Text('Amount: Rp. ${transaction.amount}'),
                            Text('Payment Method: ${transaction.paymentMethod}'),
                            Text('Date: ${transaction.date}'),
                            Text('Status: ${transaction.status}'),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Trigger PDF download when a transaction is tapped
                          downloadAndOpenPdf(transaction.kode);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
