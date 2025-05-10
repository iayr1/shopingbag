import 'package:flutter/material.dart';
import 'package:shopingbag/views/cart_screen.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> products;
  int _currentBannerIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      products = apiService.getAllProducts();
    });
  }

  // Convert USD to INR (1 USD = 83 INR)
  double convertToINR(dynamic price) {
    try {
      if (price == null) return 0.0;
      if (price is int) return price.toDouble() * 83;
      if (price is double) return price * 83;
      if (price is String) return double.parse(price) * 83;
      return 0.0;
    } catch (e) {
      print('Error converting price: $e');
      return 0.0;
    }
  }

  // Format price for display
  String formatPrice(dynamic price) {
    final convertedPrice = convertToINR(price);
    return '₹${convertedPrice.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'ShopTrend',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.teal,
        onRefresh: () async {
          _loadProducts();
          await products;
        },
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingPlaceholder();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Error loading products', style: TextStyle(fontSize: 16)),
                          TextButton(
                            onPressed: _loadProducts,
                            child: const Text('Retry', style: TextStyle(color: Colors.teal)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final allProducts = snapshot.data!;
                    final recentProducts = allProducts.take(10).toList();
                    final latestOne = allProducts.isNotEmpty ? [allProducts[0]] : [];
                    final newArrivals = allProducts.skip(10).take(10).toList();

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroBanner(),
                          const SizedBox(height: 16),
                          _buildCategoryChips(),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Recent Products'),
                          _buildHorizontalList(context, recentProducts),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Latest One', badge: 'New!'),
                          _buildHorizontalList(context, latestOne, isLatest: true),
                          const SizedBox(height: 24),
                          _buildSectionTitle('New Arrivals'),
                          _buildHorizontalList(context, newArrivals),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search, color: Colors.teal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          // Implement search suggestions logic here
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    final banners = [
      {'image': 'https://www.creativefabrica.com/wp-content/uploads/2021/04/26/Creative-Fashion-Sale-Banner-Graphics-11345601-1.jpg', 'text': 'Mega Sale! Up to 50% Off'},
      {'image': 'https://marketplace.canva.com/EAFT4iBtkRY/1/0/800w/canva-beige-brown-minimalist-casual-style-banner-landscape-nCTDUarPDJo.jpg', 'text': 'New Arrivals Await'},
      {'image': 'https://www.creativefabrica.com/wp-content/uploads/2021/04/26/Creative-Fashion-Sale-Banner-Graphics-11345601-1.jpg', 'text': 'Free Shipping on Orders'},
    ];

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      banners[index]['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('Banner Unavailable')),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        banners[index]['text']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: List.generate(
                banners.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentBannerIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentBannerIndex == index ? Colors.teal : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', 'Electronics', 'Fashion', 'Home', 'Beauty'];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: index == 0 ? Colors.white : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              selected: index == 0,
              selectedColor: Colors.teal,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.teal.withOpacity(0.3)),
              ),
              onSelected: (selected) {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? badge}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHorizontalList(BuildContext context, List<dynamic> products, {bool isLatest = false}) {
    return SizedBox(
      height: isLatest ? 340 : 280,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              final modifiedProduct = Map<String, dynamic>.from(product);
              modifiedProduct['price'] = convertToINR(product['price']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: modifiedProduct),
                ),
              );
            },
            child: Container(
              width: isLatest ? 260 : 180,
              margin: const EdgeInsets.only(right: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'product-${product['id']}',
                            child: Image.network(
                              product['image'] ?? '',
                              height: isLatest ? 200 : 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: isLatest ? 200 : 140,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported, size: 50),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: isLatest ? 200 : 140,
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator(color: Colors.teal)),
                                );
                              },
                            ),
                          ),
                          if (isLatest)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Latest',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'] ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatPrice(product['price']),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite_border, size: 20, color: Colors.teal),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: 150,
              height: 24,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}