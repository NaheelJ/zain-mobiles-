import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/products_listing_page.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);

    provider.assignCategoryFoundProductList(listData: dataBase.listData);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        centerTitle: true,
        title: Text(
          "Search",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
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
                  provider.runFilterCategory(enteringKey: enteringKey, listData: dataBase.listData);
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            Consumer<AddProductsProvider>(
              builder: (context, person, child) {
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: person.categoryFoundproducts.length,
                  padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, bottom: height * 0.4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsListingScreen(
                                categoryName: person.categoryFoundproducts[index]["Category"],
                                types: person.categoryFoundproducts[index]["type"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: width * 0.44,
                          height: height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Row(
                            children: [
                              Container(
                                height: height * 0.055,
                                width: width * 0.11,
                                decoration: BoxDecoration(
                                  color: Color(0xffE9EAF8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.folder_outlined,
                                    color: Color(0xff5F3461),
                                    size: 22,
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.05),
                              Text(
                                "${person.categoryFoundproducts[index]["Category"]}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
