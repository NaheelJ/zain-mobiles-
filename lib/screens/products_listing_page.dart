import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/product_details_screen.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class ProductsListingScreen extends StatefulWidget {
  final String? categoryName;
  final List? types;
  const ProductsListingScreen({
    super.key,
    this.categoryName,
    this.types,
  });

  @override
  State<ProductsListingScreen> createState() => _ProductsListingScreenState();
}

class _ProductsListingScreenState extends State<ProductsListingScreen> {
  Future<void> _handleRefresh() async {
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.fetchFromServer();
    provider.setSelectedTypeList(types: widget.types!, listData: dataBase.listData, categoryName: widget.categoryName!);
    provider.setProductFoundProductList(provider.selectedTypeList);
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.fetch(notifyListers: false);
    provider.assignSelectedTypeIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    dataBase.fetch(notifyListers: false);
    provider.assignSelectedTypeList(
      types: widget.types!,
      listData: dataBase.listData,
      categoryName: widget.categoryName!,
    );
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showDeleteConfirmationDialog(
                      context: context,
                      deletingThing: widget.categoryName!,
                      onDelete: () {
                        dataBase.removeCategory(categoryName: widget.categoryName!);
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: Icon(Icons.delete_outline),
                )
              ],
              centerTitle: true,
              title: Text(
                widget.categoryName!,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              shadowColor: Colors.white,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.012),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Container(
                      height: height * 0.06,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xffF6FBFF),
                      ),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search here..',
                            labelStyle: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5F3461),
                              letterSpacing: 2,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: Color(0xffF6FBFF),
                            prefixIcon: Icon(Icons.search, color: Color(0xff5F3461)),
                            contentPadding: EdgeInsets.only(left: width * 0.09),
                          ),
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (enteringKey) {
                            provider.runFilterProduct(
                              enteringKey: enteringKey,
                              categoryName: widget.categoryName!,
                              listData: dataBase.listData,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.04),
                    child: Consumer<AddProductsProvider>(builder: (context, person, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            widget.types!.length,
                            (index) {
                              return Padding(
                                padding: EdgeInsets.only(right: index == widget.types!.length - 1 ? width * 0.04 : 0.0),
                                child: InkWell(
                                  onTap: () {
                                    person.setselectedTypeIndex(index);
                                    provider.setSelectedTypeList(
                                      types: widget.types!,
                                      listData: dataBase.listData,
                                      categoryName: widget.categoryName!,
                                    );
                                    person.setProductFoundProductList(provider.selectedTypeList);
                                  },
                                  child: Container(
                                    height: height * 0.055,
                                    width: widget.types!.length == 1 ? width * 0.9 : width * 0.45,
                                    decoration: BoxDecoration(
                                      color: index == person.selectedTypeIndex ? Color(0xFF5f3461) : Colors.white,
                                      borderRadius: widget.types!.length == 1
                                          ? BorderRadius.circular(10)
                                          : index == 0
                                              ? BorderRadius.horizontal(left: Radius.circular(10))
                                              : index == widget.types!.length - 1
                                                  ? BorderRadius.horizontal(right: Radius.circular(10))
                                                  : null,
                                      border: Border.all(color: Color(0xFF5f3461)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.types![index] as String,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: index == person.selectedTypeIndex ? Colors.white : Colors.black,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: height * 0.01),
                  Consumer<AddProductsProvider>(
                    builder: (context, person, child) {
                      return person.selectedTypeList.isNotEmpty
                          ? RefreshIndicator(
                              displacement: 5,
                              backgroundColor: Colors.white,
                              color: Color(0xFF5f3461),
                              strokeWidth: 3,
                              triggerMode: RefreshIndicatorTriggerMode.onEdge,
                              onRefresh: _handleRefresh,
                              child: SizedBox(
                                width: width,
                                height: height * 0.76,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: person.productFoundProducts.length,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: height * 0.06),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailsScreen(
                                              productName: person.productFoundProducts[index]["productName"],
                                              categoryName: widget.categoryName!,
                                              productType: person.productFoundProducts[index]["productType"],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width,
                                        padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.025),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
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
                                            SizedBox(width: width * 0.03),
                                            Text(
                                              "${person.productFoundProducts[index]['productName']}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: height * 0.35),
                                SizedBox(
                                  child: Text("Products Not Found"),
                                ),
                              ],
                            );
                    },
                  ),
                  SizedBox(height: height * 0.04),
                ],
              ),
            ),
          );
  }
}
