import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nimbus/presentation/layout/adaptive.dart';
import 'package:nimbus/presentation/widgets/blog_card.dart';
import 'package:nimbus/presentation/widgets/buttons/nimbus_button.dart';
import 'package:nimbus/presentation/widgets/content_area.dart';
import 'package:nimbus/presentation/widgets/nimbus_info_section.dart';
import 'package:nimbus/presentation/widgets/spaces.dart';
import 'package:nimbus/values/values.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';

const double kSpacing = 28.0;
const double kRunSpacing = 16.0;

//TODO:: Add right padding for all views
//TODO:: Fix View All Button Designs
//TODO:: Add animation for readMore Button
//TODO:: Add proper Sizes for images etc.

class BlogSection extends StatefulWidget {
  @override
  _BlogSectionState createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  final int blogLength = Data.blogData.length;
  double currentPageIndex = 1;
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = widthOfScreen(context) - (getSidePadding(context) * 2);
    double screenHeight = heightOfScreen(context);
    double contentAreaWidth =
        responsiveSize(context, screenWidth, screenWidth * 0.6);
//    double blogImageHeight =
//        responsiveSize(context, screenHeight, screenHeight * 0.5);

    return VisibilityDetector(
      key: Key('blog-section'),
      onVisibilityChanged: (visibilityInfo) {
        double visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'Widget ${visibilityInfo.key} is $visiblePercentage% visible');
        if (visiblePercentage > 30) {
//          _text1Controller.forward();
        }
      },
      child: ContentArea(
        padding: EdgeInsets.symmetric(horizontal: getSidePadding(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResponsiveBuilder(builder: (context, sizingInformation) {
              double screenWidth = sizingInformation.screenSize.width;
              if (screenWidth <= (RefinedBreakpoints().tabletSmall)) {
                return Column(
                  children: [
                    ContentArea(
                      width: contentAreaWidth,
                      child: NimbusInfoSection2(
                        sectionTitle: StringConst.MY_BLOG,
                        title1: StringConst.BLOG_SECTION_TITLE_1,
                        title2: StringConst.BLOG_SECTION_TITLE_2,
                        body: StringConst.BLOG_DESC,
                      ),
                    ),
                    SpaceH50(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: NimbusButton(
                        buttonTitle: StringConst.BLOG_VIEW_ALL,
                        buttonColor: AppColors.primaryColor,
                        onPressed: () {},
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContentArea(
                      width: screenWidth * 0.7,
                      child: NimbusInfoSection1(
                        sectionTitle: StringConst.MY_BLOG,
                        title1: StringConst.BLOG_SECTION_TITLE_1,
                        title2: StringConst.BLOG_SECTION_TITLE_2,
                        body: StringConst.BLOG_DESC,
                      ),
                    ),
                    Spacer(),
                    NimbusButton(
                      buttonTitle: StringConst.BLOG_VIEW_ALL,
                      buttonColor: AppColors.primaryColor,
                      onPressed: () {},
                    ),
                  ],
                );
              }
            }),
            SpaceH40(),
            ResponsiveBuilder(
              builder: (context, sizingInformation) {
                double widthOfScreen = sizingInformation.screenSize.width;
                if (widthOfScreen < (RefinedBreakpoints().tabletLarge)) {
                  return Container(
                    width: widthOfScreen,
                    height: screenHeight,
                    child: CarouselSlider.builder(
                      itemCount: blogLength,
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) {
                        return BlogCard(
                          width: contentAreaWidth * 0.9,
                          height: screenHeight * 0.6,
                          category: Data.blogData[index].category,
                          title: Data.blogData[index].title,
                          date: Data.blogData[index].date,
                          buttonText: Data.blogData[index].buttonText,
                          imageUrl: Data.blogData[index].imageUrl,
                          onPressed: () {},
                        );
                      },
                      options: carouselOptions(),
                    ),
                  );
                } else if (widthOfScreen >= RefinedBreakpoints().tabletLarge &&
                    widthOfScreen <= 1024) {
                  return Container(
                    height: screenHeight,
                    width: screenWidth,
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: screenHeight * 0.9,
                          child: CarouselSlider.builder(
                            itemCount: blogLength,
                            carouselController: _carouselController,
                            itemBuilder: (BuildContext context, int index,
                                int pageViewIndex) {
                              return BlogCard(
                                width: screenWidth * 0.45,
                                height: screenHeight,
                                category: Data.blogData[index].category,
                                title: Data.blogData[index].title,
                                date: Data.blogData[index].date,
                                buttonText: Data.blogData[index].buttonText,
                                imageUrl: Data.blogData[index].imageUrl,
                                onPressed: () {},
                              );
                            },
                            options: carouselOptions(
                              viewportFraction: 0.50,
                              autoPlay: false,
                              initialPage: currentPageIndex.toInt(),
                              aspectRatio: 1,
                              enableInfiniteScroll: true,
                              enlargeCenterPage: false,
                            ),
                          ),
                        ),
                        _buildDotsIndicator(
                          pageLength: blogLength,
                          currentIndex: currentPageIndex,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: kSpacing,
                      runSpacing: kRunSpacing,
                      children: _buildBlogCards(
                        blogData: Data.blogData,
                        width: screenWidth,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  CarouselOptions carouselOptions({
    bool autoPlay = true,
    bool enlargeCenterPage = false,
    bool enableInfiniteScroll = true,
    double viewportFraction = 1.0,
    double aspectRatio = 0.1,
    int initialPage = 1,
    ScrollPhysics? scrollPhysics = const NeverScrollableScrollPhysics(),
  }) {
    return CarouselOptions(
        autoPlay: autoPlay,
        enableInfiniteScroll: enableInfiniteScroll,
        enlargeCenterPage: enlargeCenterPage,
        viewportFraction: viewportFraction,
        aspectRatio: aspectRatio,
        initialPage: initialPage,
        scrollPhysics: scrollPhysics,
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          setState(() {
            currentPageIndex = index.toDouble();
          });
        });
  }

  List<Widget> _buildBlogCards({
    required List<BlogCardData> blogData,
    required double width,
  }) {
    double cardWidth = ((width - (kSpacing * 2)) / 3);
    List<Widget> items = [];

    for (int index = 0; index < blogData.length; index++) {
      items.add(
        BlogCard(
          width: cardWidth,
          category: blogData[index].category,
          title: blogData[index].title,
          date: blogData[index].date,
          buttonText: blogData[index].buttonText,
          imageUrl: blogData[index].imageUrl,
          onPressed: () {},
        ),
      );
    }
    return items;
  }

  Widget _buildDotsIndicator({
    required int pageLength,
    required double currentIndex,
  }) {
    return Container(
      child: DotsIndicator(
        dotsCount: pageLength,
        position: currentIndex,
        onTap: (index) {
          _moveToNextCarousel(index.toInt());
        },
        decorator: DotsDecorator(
          color: AppColors.yellow10,
          activeColor: AppColors.yellow400,
          size: Size(Sizes.SIZE_6, Sizes.SIZE_6),
          activeSize: Size(Sizes.SIZE_24, Sizes.SIZE_6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(Sizes.RADIUS_8),
            ),
          ),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              const Radius.circular(Sizes.RADIUS_8),
            ),
          ),
          spacing: EdgeInsets.symmetric(horizontal: Sizes.SIZE_4),
        ),
      ),
    );
  }

  _moveToNextCarousel(int index) {
    setState(() {
      currentPageIndex = index.toDouble();
      _carouselController.animateToPage(index);
    });
  }
}
