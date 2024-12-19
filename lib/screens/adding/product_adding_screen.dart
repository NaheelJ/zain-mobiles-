import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class ProductAddingScreen extends StatefulWidget {
  final List listData;
  final List category;
  const ProductAddingScreen({
    super.key,
    required this.category,
    required this.listData,
  });

  @override
  State<ProductAddingScreen> createState() => _ProductAddingScreenState();
}

class _ProductAddingScreenState extends State<ProductAddingScreen> {
  @override
  void initState() {
    super.initState();
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.clearAllProductControllers();
    dataBase.assignCategory(widget.category[0]);
    dataBase.assignProductSelectedType();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              centerTitle: true,
              title: Text(
                "New Product",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              elevation: 0,
              shadowColor: Colors.grey.shade50,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Product Name",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    CustomTextField(controller: dataBase.productNameController),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose a Product Category",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Container(
                      width: width,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Center(
                        child: Consumer<DataBaseManagement>(
                          builder: (context, person, child) {
                            return DropdownButton<String>(
                              value: dataBase.selectedCategory,
                              menuWidth: width* 0.88,
                              dropdownColor: Colors.white,
                              alignment: Alignment.centerRight,
                              iconSize: 24,
                              icon: Icon(Icons.keyboard_arrow_down),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10),
                              elevation: 16,
                              underline: SizedBox(),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                letterSpacing: 1,
                              ),
                              onChanged: (String? newValue) {
                                dataBase.setCategory(newValue);
                                dataBase.assignProductSelectedType();
                              },
                              items: dataBase.listData.map<DropdownMenuItem<String>>((item) {
                                String? category = item["Category"] as String?;
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category!),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Product Type",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Container(
                      width: width,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Center(
                        child: Consumer<DataBaseManagement>(
                          builder: (context, person, child) => DropdownButton<String>(
                            value: dataBase.productSelectedType,
                            menuWidth: width* 0.88,
                            dropdownColor: Colors.white,
                            alignment: Alignment.centerRight,
                            iconSize: 24,
                            icon: Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 16,
                            underline: SizedBox(),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                            onChanged: (String? newValue) {
                              dataBase.setProductSelectedType(newValue);
                            },
                            items: widget.listData.firstWhere((item) => item["Category"] == dataBase.selectedCategory)["type"].map<DropdownMenuItem<String>>(
                              (value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Suitable for other Models",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Consumer<DataBaseManagement>(
                      builder: (context, person, child) => ListView.builder(
                        itemCount: dataBase.suitableFor.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextField(controller: dataBase.suitableFor[index]),
                                ),
                                index != 0
                                    ? IconButton(
                                        onPressed: () {
                                          dataBase.removeTextField(dataBase.suitableFor[index]);
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 40,
                                          color: const Color.fromARGB(255, 255, 176, 176),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          dataBase.addTextField();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xffE2BBBF),
                              size: 20,
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              'More Model',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffE2BBBF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              height: height * 0.13,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: SizedBox(
                      height: height * 0.08,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5F3461),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          dataBase.addNewProduct(
                            productName: dataBase.productNameController.text,
                            productType: dataBase.productSelectedType,
                            suitableFor: dataBase.suitableFor.map((item) => item.text).toList(),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Register New Product',
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
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextField(
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF5f3461)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: width * 0.04),
      ),
    );
  }
}
