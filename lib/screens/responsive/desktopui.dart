import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api_controller.dart';
import 'package:news_app/screens/bottom_navigagtion/bottom_controller.dart';
import 'package:news_app/sort.dart';
import 'package:news_app/widgets/hover.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Desktopui extends StatefulWidget{
  const Desktopui({Key? key}):super(key: key);

  @override
  State<Desktopui> createState() => _DesktopuiState();
}

class _DesktopuiState extends State<Desktopui> {
  final ApiController data = Get.put(ApiController());
  final BottomController bottomController=Get.put(BottomController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searching = TextEditingController();
  final SortController controller = Get.put(SortController());
  Timer? _searchdebouncer;
  void startsearch(String value) {
    if (_searchdebouncer?.isActive ?? false) {
      _searchdebouncer!.cancel();
    }
    _searchdebouncer = Timer(const Duration(milliseconds: 500), () {
      if (value.length > 4) {
        data.type.value = value;
        data.fetchnews();
      }
    });
  }
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!data.isMoreLoading.value && !data.isLoading.value) {
          data.loadnews();
        }
      }
    });
  }
  @override
  void dispose() {
    _searchdebouncer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0.5,
        title: const Text(
          'Daily News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // Screen size ke hisab se adjust hoga
            child: TextField(
              controller: searching,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  startsearch(value);
                } else {
                  data.type.value = 'india';
                  data.filter.value = 'everything';
                  data.queryfilter.value = '';
                  data.fetchnews();
                }
              },
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: searching.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                  onPressed: () {
                    searching.clear();
                    data.type.value = "india";
                    data.filter.value = "everything";
                    data.queryfilter.value = "";
                    data.fetchnews();
                  },
                )
                    : const SizedBox.shrink(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              ),
            ),
          ),


          PopupMenuButton<int>(
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (index) {
              bottomController.change(index);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 0, // Home ka index
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Home'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1, // Profile ka index
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        'Filters',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomFilterChip(
                        label: 'Everything',
                        onTap: () {
                          data.filter.value = 'everything';
                          data.fetchnews();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CustomFilterChip(
                        label: 'Popularity',
                        icon: Icons.trending_up,
                        onTap: () {
                          data.queryfilter.value = '&sortBy=popularity';
                          data.fetchnews();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CustomFilterChip(
                        label: 'Business',
                        icon: Icons.business,
                        onTap: () {
                          data.queryfilter.value = '&category=business';
                          data.fetchnews();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CustomFilterChip(
                        label: 'Top Headlines',
                        icon: Icons.star,
                        onTap: () {
                          data.filter.value = 'top-headlines';
                          data.fetchnews();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CustomFilterChip(
                        label: 'Sort by Date',
                        icon: Icons.calendar_today,
                        isPrimary: true,
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
                                'Select Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: Obx(
                                      () => DayPicker.single(
                                    selectedDate: controller.selecteddate.value,
                                    onChanged: (DateTime date) {
                                      controller.updatedate(date);
                                      String formatdate = DateFormat('yyyy-MM-dd')
                                          .format(controller.selecteddate.value);
                                      data.queryfilter.value =
                                      '&from=$formatdate&sortBy=publishedAt';
                                      data.fetchnews();
                                      Get.back();
                                    },
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 10),
                                    ),
                                    lastDate: DateTime.now(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              child: Obx(() {
                if (data.isLoading.value) {
                  return Shimmer(
                    direction: ShimmerDirection.fromLeftToRight(),
                    interval: const Duration(milliseconds: 100),
                    duration: const Duration(seconds: 2),
                    color: Colors.white,
                    colorOpacity: 0.3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.black38,
                            child: CarouselSlider.builder(
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  padding: const EdgeInsets.all(16),
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 180,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                scrollDirection: Axis.horizontal,
                                autoPlay: false,
                                viewportFraction: 0.8,
                                height: 200,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 130,
                                  child: Card(
                                    color: Colors.grey.shade100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await data.fetchnews();
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 220, child: Hover()),
                          const SizedBox(height: 20),

                          NewsCard(),

                          // 3. Pagination Loader Section
                          if (data.isMoreLoading.value)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      )
    );
  }
}
class CustomFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize = (screenWidth * 0.012).clamp(11.0, 14.0);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.yellow[700] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPrimary ? Colors.transparent : Colors.grey[300]!,
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary ? Colors.black : Colors.black87,
                ),
                const SizedBox(width: 6),
              ],


              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsiveFontSize,
                    fontWeight: FontWeight.w600,
                    color: isPrimary ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
