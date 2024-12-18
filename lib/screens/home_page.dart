import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_category.dart';
import 'package:zain_mobiles/screens/adding/adding_page.dart';
import 'package:zain_mobiles/screens/products_listing_page.dart';
import 'package:zain_mobiles/screens/search_screen.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
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
                                          productList: dataBase.listData[index]["products"],
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AddProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: height * 0.08,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.045,
              width: width * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/minilogo.png"),
                ),
              ),
            ),
            Consumer<AddProductsProvider>(
              builder: (context, person, child) => Text(
                person.currentPage == 0 ? "Home" : "Add Products",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5f3461),
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(width: width * 0.1),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: PageView(
        controller: provider.pageController,
        onPageChanged: (index) {
          provider.setSelectedPageIndex(index);
        },
        children: [
          HomePage(),
          AddingPage(),
        ],
      ),
      bottomNavigationBar: Consumer<AddProductsProvider>(
        builder: (context, person, child) => DotCurvedBottomNav(
          selectedIndex: person.currentPage,
          margin: EdgeInsets.all(0),
          scrollController: ScrollController(),
          hideOnScroll: true,
          indicatorColor: Color(0xFF5f3461),
          backgroundColor: Color(0xFF5f3461),
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeOut,
          indicatorSize: 5,
          borderRadius: 0,
          height: 70,
          onTap: (index) {
            person.setSelectedPageIndex(index);
            person.pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          items: [
            Icon(
              Icons.home,
              color: person.currentPage == 0 ? Color(0xffE2BBBF) : Color(0xffE9EAF8),
              size: 25,
            ),
            Icon(
              Icons.add_box_rounded,
              color: person.currentPage == 1 ? Color(0xffE2BBBF) : Color(0xffE9EAF8),
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
