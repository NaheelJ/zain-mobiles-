import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/products_listing_page.dart';
import 'package:zain_mobiles/screens/search_screen.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleRefresh() async {
    final provider = Provider.of<DataBaseManagement>(context, listen: false);
    provider.fetchFromServer();
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DataBaseManagement>(context, listen: false);
    provider.fetchFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dataBase = Provider.of<DataBaseManagement>(context, listen: false);
    return Provider.of<DataBaseManagement>(context).isLoading
        ? LoadingScreen()
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
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
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Search here..',
                          hintStyle: GoogleFonts.montserrat(
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
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Text(
                        "Categories",
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffE2BBBF),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    RefreshIndicator(
                      displacement: 5,
                      backgroundColor: Colors.white,
                      color: Color(0xFF5f3461),
                      strokeWidth: 3,
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: _handleRefresh,
                      child: SizedBox(
                        height: height,
                        child: Consumer<DataBaseManagement>(
                          builder: (context, person, child) {
                            person.fetch();
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: height * 1.1 / width,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: height * 0.02,
                              ),
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dataBase.listData.length,
                              padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, bottom: height * 0.4),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductsListingScreen(
                                          categoryName: dataBase.listData[index]["Category"],
                                          types: dataBase.listData[index]["type"],
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
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.00),
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
                                        Spacer(),
                                        SizedBox(
                                          width: width * 0.24,
                                          child: Text(
                                            "${dataBase.listData[index]["Category"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
  }
}

