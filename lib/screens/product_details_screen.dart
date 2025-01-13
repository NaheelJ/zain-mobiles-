import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/adding/product_adding_screen.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productType;
  final String categoryName;
  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.productType,
    required this.categoryName,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Future<void> _handleRefresh() async {
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.fetchFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);

    dataBase.fetch(notifyListers: true);
    provider.assignSuitableProductsList(
      listData: dataBase.listData,
      categoryName: widget.categoryName,
      productName: widget.productName,
    );
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              title: Text(
                widget.productName,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          showDeleteConfirmationDialog(
                            context: context,
                            deletingThing: "product",
                            onDelete: () {
                              dataBase.removeProduct(
                                productName: widget.productName,
                                categoryName: widget.categoryName,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Text(
                          'Delete',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
                SizedBox(width: width * 0.01),
              ],
              shadowColor: Colors.grey.shade50,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            body: RefreshIndicator(
              displacement: 5,
              backgroundColor: Colors.white,
              color: Color(0xFF5f3461),
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),
                      Container(
                        width: width,
                        padding: EdgeInsets.symmetric(vertical: height * 0.03, horizontal: width * 0.04),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 252, 229, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFF5f3461),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Suitable Models',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Divider(color: Colors.white),
                            SizedBox(height: height * 0.005),
                            Consumer<AddProductsProvider>(
                              builder: (context, person, child) {
                                return ListView.builder(
                                  itemCount: person.suitableProducts.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.015),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF5f3461)),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "${index + 1}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.04),
                                          Text(
                                            '${person.suitableProducts[index]}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.06),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              height: height * 0.12,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5F3461),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          addMoreModelShowDialogue(
                            context: context,
                            onAdd: () {
                              dataBase.addSuitableFor(
                                categoryName: widget.categoryName,
                                productName: widget.productName,
                                newSuitableFor: dataBase.suitableForcontroller.text,
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            'Add Model',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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

  Future<dynamic> addMoreModelShowDialogue({required BuildContext context, required VoidCallback onAdd}) {
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'New Model Name',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5f3461),
                letterSpacing: 1,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Model Name",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5f3461),
                    letterSpacing: 1,
                  ),
                ),
                CustomTextField(controller: dataBase.suitableForcontroller),
                SizedBox(height: 5),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                dataBase.suitableForcontroller.clear();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onAdd();
                Navigator.pop(context);
                dataBase.suitableForcontroller.clear();
              },
              child: Text(
                'Add',
                style: GoogleFonts.montserrat(
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onDelete,
  required String deletingThing,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with circular background
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 48.0,
                ),
              ),
              const SizedBox(height: 16.0),

              // Title
              Text(
                "Delete $deletingThing",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              // Subtitle
              Text(
                "Are you sure you want to delete this $deletingThing?\nThis action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24.0),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xffF6FBFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context); // Close dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      child: const Text("Delete"),
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
