import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() { 
  runApp(const MyApp()); 
}

// Enhanced Product model with additional features
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isOnSale;
  final List<String> features;
  final bool isFavorite;
  final String brand;
  
  Product({
    required this.id,
    required this.name, 
    required this.description, 
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isOnSale = false,
    this.features = const [],
    this.isFavorite = false,
    this.brand = '',
  });
  
  double get discountPercentage => 
    ((originalPrice - price) / originalPrice * 100);
    
  Product copyWith({bool? isFavorite}) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      originalPrice: originalPrice,
      imageUrl: imageUrl,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      isOnSale: isOnSale,
      features: features,
      isFavorite: isFavorite ?? this.isFavorite,
      brand: brand,
    );
  }
}

// Enhanced sample products with professional styling
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: "Premium Cotton Business Shirt", 
    description: "Professional cotton shirt crafted with premium Egyptian cotton. Perfect for business meetings and formal occasions. Features moisture-wicking technology and wrinkle-resistant fabric.", 
    price: 89.99,
    originalPrice: 129.99,
    imageUrl: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=400&fit=crop",
    category: "Clothing",
    rating: 4.7,
    reviewCount: 324,
    isOnSale: true,
    brand: "ModernWear",
    features: ["Egyptian Cotton", "Wrinkle Resistant", "Moisture Wicking"],
  ),
  Product(
    id: '2',
    name: "Designer Denim Jeans", 
    description: "Premium slim-fit denim jeans made from sustainable organic cotton. Features reinforced stitching and a comfortable stretch design for all-day wear.", 
    price: 124.99,
    originalPrice: 124.99,
    imageUrl: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=400&fit=crop",
    category: "Clothing",
    rating: 4.4,
    reviewCount: 189,
    brand: "UrbanStyle",
    features: ["Organic Cotton", "Stretch Fit", "Reinforced Stitching"],
  ),
  Product(
    id: '3',
    name: "Smart Fitness Tracker Pro", 
    description: "Advanced fitness tracking smartwatch with comprehensive health monitoring. Features GPS, heart rate tracking, sleep analysis, and 14-day battery life.", 
    price: 299.99,
    originalPrice: 399.99,
    imageUrl: "https://images.unsplash.com/photo-1544117519-31a4b719223d?w=400&h=400&fit=crop",
    category: "Electronics",
    rating: 4.8,
    reviewCount: 1256,
    isOnSale: true,
    brand: "TechPro",
    features: ["GPS Tracking", "Heart Rate Monitor", "14-Day Battery", "Sleep Analysis"],
  ),
  Product(
    id: '4',
    name: "Wireless Noise-Cancelling Earbuds", 
    description: "Premium wireless earbuds with active noise cancellation and studio-quality sound. Features quick charge technology and ergonomic design for ultimate comfort.", 
    price: 179.99,
    originalPrice: 229.99,
    imageUrl: "https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=400&h=400&fit=crop",
    category: "Electronics",
    rating: 4.6,
    reviewCount: 892,
    isOnSale: true,
    brand: "SoundWave",
    features: ["Active Noise Cancellation", "Quick Charge", "Studio Quality", "Ergonomic Design"],
  ),
  Product(
    id: '5',
    name: "Athletic Performance Sneakers", 
    description: "High-performance running shoes with advanced cushioning technology and breathable mesh upper. Designed for comfort during intense workouts and daily activities.", 
    price: 159.99,
    originalPrice: 159.99,
    imageUrl: "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop",
    category: "Footwear",
    rating: 4.5,
    reviewCount: 567,
    brand: "SportTech",
    features: ["Advanced Cushioning", "Breathable Mesh", "Lightweight Design", "Durable Sole"],
  ),
  Product(
    id: '6',
    name: "Executive Leather Backpack", 
    description: "Premium full-grain leather backpack designed for professionals. Features dedicated laptop compartment, multiple organization pockets, and water-resistant treatment.", 
    price: 249.99,
    originalPrice: 329.99,
    imageUrl: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=400&fit=crop",
    category: "Accessories",
    rating: 4.9,
    reviewCount: 234,
    isOnSale: true,
    brand: "Executive",
    features: ["Full-Grain Leather", "Laptop Compartment", "Water Resistant", "Multiple Pockets"],
  ),
  Product(
    id: '7',
    name: "Luxury Silk Scarf", 
    description: "Handcrafted silk scarf with elegant patterns. Made from 100% pure mulberry silk with hand-rolled edges. Perfect accessory for any sophisticated outfit.", 
    price: 79.99,
    originalPrice: 79.99,
    imageUrl: "https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=400&fit=crop",
    category: "Accessories",
    rating: 4.6,
    reviewCount: 156,
    brand: "Elegance",
    features: ["100% Mulberry Silk", "Hand-rolled Edges", "Elegant Patterns", "Handcrafted"],
  ),
  Product(
    id: '8',
    name: "Professional Chef's Knife", 
    description: "High-carbon stainless steel chef's knife with ergonomic handle. Perfect balance and razor-sharp edge for professional cooking and food preparation.", 
    price: 129.99,
    originalPrice: 169.99,
    imageUrl: "https://images.unsplash.com/photo-1544168190-79c17527004f?w=400&h=400&fit=crop",
    category: "Kitchen",
    rating: 4.8,
    reviewCount: 445,
    isOnSale: true,
    brand: "ChefMaster",
    features: ["High-Carbon Steel", "Ergonomic Handle", "Professional Grade", "Razor Sharp"],
  ),
];

List<Product> cart = [];

// EmailJS Service Class
class EmailJSService {
  static const String _serviceId = 'service_9n2rlr5';
  static const String _templateId = 'template_icysguc';
  static const String _publicKey = '5nivqhNinSfXdeTU5';
  static const String _emailJSUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  static Future<bool> sendOrderConfirmationEmail({
    required String customerEmail,
    required String customerName,
    required String orderNumber,
    required List<Product> orderItems,
    required double totalAmount,
    required String deliveryAddress,
    required String phoneNumber,
  }) async {
    try {
      // Create orders array for the template
      final ordersArray = orderItems.map((item) {
        // Get quantity of this item in cart
        final quantity = orderItems.where((cartItem) => cartItem.id == item.id).length;
        return {
          'name': item.name,
          'image_url': item.imageUrl,
          'units': quantity,
          'price': '\$${(item.price * quantity).toStringAsFixed(2)}'
        };
      }).toList();

      // Remove duplicates by converting to a map and back
      final Map<String, Map<String, dynamic>> uniqueOrders = {};
      for (var order in ordersArray) {
        uniqueOrders[order['name'] as String] = order;
      }

      final DateTime orderDate = DateTime.now();
      final DateTime estimatedDelivery = orderDate.add(const Duration(days: 5));

      final templateParams = {
        'email': customerEmail,
        'to_name': customerName,
        'order_id': orderNumber,
        'orders': uniqueOrders.values.toList(),
        'cost': {
          'shipping': 'FREE',
          'tax': '\$0.00',
          'total': '\$${totalAmount.toStringAsFixed(2)}'
        },
        'order_date': '${orderDate.day}/${orderDate.month}/${orderDate.year}',
        'estimated_delivery': '${estimatedDelivery.day}/${estimatedDelivery.month}/${estimatedDelivery.year}',
        'customer_name': customerName,
        'shipping_address': deliveryAddress,
        'payment_method': 'Cash on Delivery',
        'tracking_url': 'https://modernshop.com/tracking?order=$orderNumber',
        'website_url': 'https://modernshop.com'
      };

      final response = await http.post(
        Uri.parse(_emailJSUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': templateParams,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Order confirmation email sent successfully!');
        return true;
      } else {
        print('❌ Failed to send email. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      return false;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EliteShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF1B365D),
          secondary: const Color(0xFFE8A87C),
          surface: Colors.white,
          background: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B365D),
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B365D),
          ),
          bodyLarge: GoogleFonts.inter(
            color: const Color(0xFF2D3748),
          ),
          bodyMedium: GoogleFonts.inter(
            color: const Color(0xFF4A5568),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1B365D),
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: Colors.black12,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B365D),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B365D),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: const Color(0xFF1B365D).withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          shadowColor: Colors.black12,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF1B365D),
          disabledColor: Colors.grey[200],
          labelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      home: const ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Clothing', 'Electronics', 'Footwear', 'Accessories', 'Kitchen'];
  
  List<Product> get filteredProducts {
    if (selectedCategory == 'All') return sampleProducts;
    return sampleProducts.where((p) => p.category == selectedCategory).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Professional App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1B365D),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'EliteShop',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B365D),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: badges.Badge(
                              badgeContent: Text(
                                '${cart.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              showBadge: cart.isNotEmpty,
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Color(0xFFE8A87C),
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (_) => const CartScreen())
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined, 
                                  size: 24,
                                  color: Color(0xFF1B365D),
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
            ),
            
            // Search and Filter Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Premium Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search premium products...',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF1B365D),
                            size: 24,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B365D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Category Filters with Professional Design
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1B365D) : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF1B365D) : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: const Color(0xFF1B365D).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ] : [],
                                ),
                                child: Text(
                                  category,
                                  style: GoogleFonts.inter(
                                    color: isSelected ? Colors.white : const Color(0xFF4A5568),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    fontSize: 14,
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
            
            // Products Grid with Premium Design
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: widget.product))
            ),
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Professional Overlay
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey[100]!,
                                Colors.grey[50]!,
                              ],
                            ),
                          ),
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey[200]!,
                                    Colors.grey[100]!,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image_outlined, 
                                  size: 40, 
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Sale Badge with Premium Design
                      if (widget.product.isOnSale)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '${widget.product.discountPercentage.round()}% OFF',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      
                      // Favorite Button with Glassmorphism Effect
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: widget.product.isFavorite 
                                ? const Color(0xFFE8A87C) 
                                : const Color(0xFF1B365D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Product Information with Professional Typography
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand Name
                        if (widget.product.brand.isNotEmpty)
                          Text(
                            widget.product.brand.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFE8A87C),
                              letterSpacing: 1.2,
                            ),
                          ),
                        
                        const SizedBox(height: 4),
                        
                        // Product Name
                        Text(
                          widget.product.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B365D),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Rating and Reviews
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < widget.product.rating.floor()
                                    ? Icons.star_rounded
                                    : index < widget.product.rating
                                        ? Icons.star_half_rounded
                                        : Icons.star_outline_rounded,
                                size: 14,
                                color: const Color(0xFFFFB800),
                              );
                            }),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.product.rating}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4A5568),
                              ),
                            ),
                            Text(
                              ' (${widget.product.reviewCount})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Price Section with Professional Styling
                        Row(
                          children: [
                            Text(
                              '\$${widget.product.price.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                            if (widget.product.isOnSale) ...[
                              const SizedBox(width: 8),
                              Text(
                                '\$${widget.product.originalPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey[500],
                                ),
                              ),
                            ],
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
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Product Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
              IconButton(
                icon: badges.Badge(
                  badgeContent: Text(
                    '${cart.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  showBadge: cart.isNotEmpty,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
                  ),
                  if (widget.product.isOnSale)
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.product.discountPercentage.round()}% OFF',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Product Details
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.product.rating}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Reviews Count
                  Text(
                    '${widget.product.reviewCount} reviews',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Price Section
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6750A4),
                        ),
                      ),
                      if (widget.product.isOnSale) ...[
                        const SizedBox(width: 12),
                        Text(
                          '\$${widget.product.originalPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.product.category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Quantity:',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1 ? () {
                                setState(() {
                                  quantity--;
                                });
                              } : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$quantity',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Add to Cart Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  'Add to Cart - \$${(widget.product.price * quantity).toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  for (int i = 0; i < quantity; i++) {
                    cart.add(widget.product);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$quantity ${widget.product.name}${quantity > 1 ? 's' : ''} added to cart',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF6750A4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  setState(() {
                    quantity = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get total => cart.fold(0, (sum, p) => sum + p.price);
  
  Map<String, int> get groupedCart {
    Map<String, int> grouped = {};
    for (var product in cart) {
      grouped[product.id] = (grouped[product.id] ?? 0) + 1;
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: cart.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Your cart is empty",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add some products to get started",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Continue Shopping",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedCart.length,
                  itemBuilder: (ctx, i) {
                    final productId = groupedCart.keys.elementAt(i);
                    final quantity = groupedCart[productId]!;
                    final product = sampleProducts.firstWhere((p) => p.id == productId);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)} each',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Quantity Controls
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cart.removeWhere((item) => item.id == productId);
                                                  cart.addAll(List.filled(quantity - 1, product));
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: quantity > 1 ? Colors.black87 : Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                '$quantity',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cart.add(product);
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      const Spacer(),
                                      
                                      // Total Price for this item
                                      Text(
                                        '\$${(product.price * quantity).toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6750A4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Delete Button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  cart.removeWhere((item) => item.id == productId);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Summary and Checkout
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Order Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal (${cart.length} items)",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Free",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6750A4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(total: total),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Proceed to Checkout",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final double total;
  const CheckoutScreen({super.key, required this.total});
  
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  bool isLoading = false;
  
  String generateOrderNumber() {
    final now = DateTime.now();
    return 'MS${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                color: const Color(0xFF6750A4),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Order Summary",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal (${cart.length} items)",
                                style: GoogleFonts.poppins(color: Colors.grey[600]),
                              ),
                              Text(
                                "\$${widget.total.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Fee",
                                style: GoogleFonts.poppins(color: Colors.grey[600]),
                              ),
                              Text(
                                "Free",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${widget.total.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6750A4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Delivery Information
                    Text(
                      "Delivery Information",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Form Fields
                    _buildTextField(
                      controller: nameCtrl,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: emailCtrl,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: phoneCtrl,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: addressCtrl,
                      label: "Delivery Address",
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your delivery address';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Method
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payment, color: Colors.green[700]),
                          const SizedBox(width: 12),
                          Text(
                            "Payment Method: Cash on Delivery",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Place Order Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      
                      // Generate order number
                      final orderNumber = generateOrderNumber();
                      
                      // Send confirmation email using EmailJS
                      final emailSent = await EmailJSService.sendOrderConfirmationEmail(
                        customerEmail: emailCtrl.text,
                        customerName: nameCtrl.text,
                        orderNumber: orderNumber,
                        orderItems: cart,
                        totalAmount: widget.total,
                        deliveryAddress: addressCtrl.text,
                        phoneNumber: phoneCtrl.text,
                      );
                      
                      cart.clear();
                      
                      if (!mounted) return;
                      
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Order Placed!",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order Number: $orderNumber",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6750A4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Your order has been confirmed and will be delivered to your address.",
                                style: GoogleFonts.poppins(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emailSent 
                                  ? "✅ Confirmation email sent to ${emailCtrl.text}"
                                  : "⚠️ Order confirmed but email couldn't be sent. Please note your order number.",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: emailSent ? Colors.green[700] : Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.popUntil(context, (r) => r.isFirst);
                              },
                              child: Text(
                                "Continue Shopping",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6750A4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Placing Order...",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : Text(
                        "Place Order (Cash on Delivery)",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
