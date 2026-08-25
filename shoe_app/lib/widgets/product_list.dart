import 'package:flutter/material.dart';
import 'package:shoe_app/global_variables.dart';
import 'package:shoe_app/widgets/product_card.dart';
import 'package:shoe_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final filters = const ['All', 'Nike', 'Adidas', 'Bata'];
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    const searchBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Shoes\nCollection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: searchBorder,
                    enabledBorder: searchBorder,
                    focusedBorder: searchBorder,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = filter == selectedFilter;

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: FilterChipButton(
                        label: filter,
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                      ),
                    )
                    //     ChoiceChip(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 20),
                    //   label: Text(filter),
                    //   selected: isSelected,
                    //   showCheckmark: false,
                    //   elevation: isSelected ? 8 : 2,
                    //   pressElevation: 10,
                    //   backgroundColor: const Color.fromRGBO(245, 247, 249, 1),
                    //   side: BorderSide.none,
                    //   labelStyle: TextStyle(
                    //     fontSize: 15,
                    //     color: isSelected ? Colors.white : Colors.black,
                    //   ),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(60),
                    //   ),
                    //   onSelected: (_) {
                    //     setState(() {
                    //       selectedFilter = filter;
                    //     });
                    //   },
                    // ),
                    );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 1080) {
                return GridView.builder(
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.75,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailsPage(product: product);
                              },
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product['title'] as String,
                          price: product['price'] as double,
                          image: product['imageUrl'] as String,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    });
              } else {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ProductDetailsPage(product: product);
                            },
                          ),
                        );
                      },
                      child: ProductCard(
                        title: product['title'] as String,
                        price: product['price'] as double,
                        image: product['imageUrl'] as String,
                        backgroundColor: index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                      ),
                    );
                  },
                );
              }
            }),
          )
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.transparent,
      elevation: selected ? 8 : 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(60),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? const Color.fromARGB(255, 238, 208, 131)
                : const Color.fromRGBO(245, 247, 249, 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
