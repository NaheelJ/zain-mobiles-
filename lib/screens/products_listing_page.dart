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
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              centerTitle: true,
              title: Text(
                widget.categoryName!,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  iconColor: Colors.white,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          showDeleteConfirmationDialog(
                            context: context,
                            deletingThing: "Category",
                            onDelete: () {
                              dataBase.removeCategory(categoryName: widget.categoryName!);
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
              ],
              shadowColor: Colors.white,
              backgroundColor: Color(0xFF5f3461),
              surfaceTintColor: Color(0xFF5f3461),
            ),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF5f3461),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.02,
                      ),
                      child: Container(
                        height: height * 0.055,
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
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.055,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                    ),
                    padding: EdgeInsets.only(left: width * 0.04, bottom: height * 0.015),
                    child: Consumer<AddProductsProvider>(
                      builder: (context, person, child) => ListView.builder(
                        itemCount: widget.types!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(right: widget.types!.length == 1 ? width * 0.0 : width * 0.04),
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
                              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.006),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: index != person.selectedTypeIndex ? Colors.grey.shade300 : Colors.amber,
                                ),
                              ),
                              child: Text(
                                widget.types![index] as String,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: index == person.selectedTypeIndex ? FontWeight.w600 : FontWeight.w400,
                                  color: index != person.selectedTypeIndex ? Colors.grey.shade700 : Colors.amber,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                              child: Container(
                                width: width,
                                height: height * 0.76,
                                color: Colors.grey.shade50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: person.productFoundProducts.length,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, bottom: height * 0.1, top: 15),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: height * 0.015),
                                      child: Column(
                                        children: [
                                          GestureDetector(
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
                                              padding: EdgeInsets.symmetric(horizontal: width * 0.032, vertical: height * 0.025),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    color: Colors.grey.shade300,
                                                    offset: const Offset(1, -2),
                                                  ),
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    color: Colors.grey.shade300,
                                                    offset: const Offset(-2, 1),
                                                  ),
                                                ],
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
                                                  SizedBox(width: width * 0.035),
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
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider.setDropDownsheet(index);
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Color(0xffF6FBFF),
                                                      child: Consumer<AddProductsProvider>(
                                                        builder: (context, person, child) =>
                                                            Icon(person.isDropDownOpen[index] || person.productFoundProducts.length == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_sharp),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Consumer<AddProductsProvider>(
                                            builder: (context, person, child) => Visibility(
                                              visible: person.isDropDownOpen[index] || person.productFoundProducts.length == 1,
                                              child: Container(
                                                width: width,
                                                margin: EdgeInsets.only(bottom: height * 0.015),
                                                padding: EdgeInsets.symmetric(vertical: height * 0.004),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(
                                                    bottom: Radius.circular(10),
                                                  ),
                                                  border: Border(
                                                    left: BorderSide(color: Colors.grey.shade300),
                                                    right: BorderSide(color: Colors.grey.shade300),
                                                    bottom: BorderSide(color: Colors.grey.shade300),
                                                  ),
                                                ),
                                                child: ListView.builder(
                                                  itemCount: person.productFoundProducts[index]['suitableFor'].length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.all(0),
                                                  itemBuilder: (context, minIndex) => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: height * 0.06,
                                                        width: width,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border(
                                                            bottom: BorderSide(color: minIndex == person.productFoundProducts[index]['suitableFor'].length - 1 ? Colors.white : Colors.grey.shade300),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            person.productFoundProducts[index]['suitableFor'][minIndex],
                                                            style: GoogleFonts.montserrat(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.black,
                                                              letterSpacing: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                  SizedBox(height: height * 0.1),
                ],
              ),
            ),
          );
  }
}
