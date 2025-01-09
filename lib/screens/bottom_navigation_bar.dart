import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/adding/adding_page.dart';
import 'package:zain_mobiles/screens/home_page.dart';
import 'package:zain_mobiles/view_model/add_products_provider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';


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
        builder: (context, person, child) => SizedBox(
          height: height * 0.09,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.025),
            child: CustomNavigationBar(
              elevation: 15,
              iconSize: 25.0,
              borderRadius: Radius.circular(10),
              strokeColor: Colors.white,
              selectedColor: Color(0xFF5f3461),
              unSelectedColor: Color(0xffacacac),
              backgroundColor: Colors.white,
              items: [
                CustomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, color: person.currentPage == 0 ? Color(0xFF5f3461) : Color(0xffacacac),),
                  title: Text(
                    "Home",
                    style: GoogleFonts.montserrat(
                      color: person.currentPage == 0 ? Color(0xFF5f3461) : Color(0xffacacac),
                      fontWeight: person.currentPage == 0 ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined,color: person.currentPage == 1 ? Color(0xFF5f3461) : Color(0xffacacac)),
                  title: Text(
                    "Members",
                    style: GoogleFonts.montserrat(
                      color:  person.currentPage == 1 ? Color(0xFF5f3461) : Color(0xffacacac),
                      fontWeight: person.currentPage == 1 ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              currentIndex: person.currentPage,
              onTap: (index) {
                person.setSelectedPageIndex(index);
              person.pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
              },
            ),
          ),
        ),
      ),
    );
  }
}
