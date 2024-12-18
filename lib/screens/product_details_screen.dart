import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/adding/product_adding_screen.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  List suitableForList;
  final String productType;
  final String categoryName;
  ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.suitableForList,
    required this.productType,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        :  Scaffold(
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
                productName,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showDeleteConfirmationDialog(
                      context: context,
                      deletingThing: "productName",
                      onDelete: () {
                        dataBase.removeProduct(
                          productName: productName,
                          categoryName: categoryName,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: width * 0.01),
              ],
              shadowColor: Colors.grey.shade50,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            body: SingleChildScrollView(
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
                            builder: (context, provider, child) {
                              var category = dataBase.listData.firstWhere((item) => item['Category'] == categoryName, orElse: () => null);
                              var product = category['products']?.firstWhere(
                                (prod) => prod['productName'] == productName,
                                orElse: () => null,
                              );
                              suitableForList = product["suitableFor"] ?? [];
                              return ListView.builder(
                                itemCount: suitableForList.length, // Number of items in the list
                                shrinkWrap: true, // Adjusts size based on content
                                physics: NeverScrollableScrollPhysics(), // Prevents independent scrolling
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.015),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFF5f3461),
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "${i + 1}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                                        Text(
                                          '${suitableForList[i]}',
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
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              height: height * 0.12,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: SizedBox(
                      height: 55,
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
                                categoryName: categoryName,
                                productName: productName,
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
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Delete",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.redAccent.shade200,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this $deletingThing?",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onDelete(); // Execute the delete action
            },
            child: Text(
              "Delete",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      );
    },
  );
}
