import 'package:flutter/material.dart';

// ─── Data Models ────────────────────────────────────────────────

class HamperProduct {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final String category;
  final List<String> tags;
  final List<String> contents;
  bool isFavorite;

  HamperProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.price,
    this.oldPrice,
    this.rating = 4.5,
    this.reviews = 0,
    required this.category,
    this.tags = const [],
    this.contents = const [],
    this.isFavorite = false,
  });
}

class CartItem {
  final HamperProduct product;
  int quantity;
  String? giftNote;
  String wrappingStyle;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.giftNote,
    this.wrappingStyle = 'Classic Pink',
  });

  double get total => product.price * quantity;
}

class CustomHamperSelection {
  String? basket;
  String? flowers;
  String? chocolate;
  String? teddy;
  String? perfume;
  String? cake;
  String? greetingCard;
  String? decoration;
  String wrappingStyle;

  CustomHamperSelection({this.wrappingStyle = 'Satin Ribbon'});

  double get totalPrice {
    double total = 0;
    if (basket != null) total += 299;
    if (flowers != null) total += 499;
    if (chocolate != null) total += 349;
    if (teddy != null) total += 599;
    if (perfume != null) total += 899;
    if (cake != null) total += 449;
    if (greetingCard != null) total += 99;
    if (decoration != null) total += 199;
    return total;
  }

  int get stepsDone {
    int count = 0;
    if (basket != null) count++;
    if (flowers != null) count++;
    if (chocolate != null) count++;
    if (teddy != null) count++;
    if (perfume != null) count++;
    if (cake != null) count++;
    if (greetingCard != null) count++;
    if (decoration != null) count++;
    return count;
  }
}

// ─── Order Tracking ─────────────────────────────────────────────

enum OrderStatus { preparing, packaging, outForDelivery, delivered }

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    this.status = OrderStatus.preparing,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

// ─── App State ──────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  // ── Navigation ──
  int _currentTab = 0;
  int get currentTab => _currentTab;
  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  // ── Auth ──
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  String userName = 'Sarah';

  void login(String name) {
    userName = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // ── Products ──
  final List<HamperProduct> allProducts = [
    HamperProduct(
      id: '1', name: 'Luxury Chocolate Hamper', emoji: '🍫',
      description: 'Premium Belgian chocolates, artisan cookies & imported wine in an elegant gift box.',
      price: 2499, oldPrice: 3299, rating: 4.8, reviews: 342,
      category: 'Luxury', tags: ['Best Seller', 'Premium'],
      contents: ['Belgian Chocolates', 'Artisan Cookies', 'Red Wine', 'Gift Card'],
    ),
    HamperProduct(
      id: '2', name: 'Festive Delight Hamper', emoji: '🎉',
      description: 'Hand-curated dry fruits, traditional sweets & decorative candles for celebrations.',
      price: 1999, oldPrice: 2499, rating: 4.6, reviews: 218,
      category: 'Festive', tags: ['Popular'],
      contents: ['Premium Dry Fruits', 'Kaju Katli', 'Scented Candles', 'Rangoli Kit'],
    ),
    HamperProduct(
      id: '3', name: 'Corporate Gift Hamper', emoji: '💼',
      description: 'Specialty coffee, leather planner & gourmet snack selection for professionals.',
      price: 2999, oldPrice: 3999, rating: 4.7, reviews: 156,
      category: 'Corporate', tags: ['New'],
      contents: ['Specialty Coffee', 'Leather Planner', 'Gourmet Snacks', 'Pen Set'],
    ),
    HamperProduct(
      id: '4', name: 'Birthday Surprise Box', emoji: '🎂',
      description: 'Colorful balloon set, birthday cake candles & party confetti hamper.',
      price: 1499, oldPrice: 1999, rating: 4.9, reviews: 487,
      category: 'Birthday', tags: ['Trending', 'Best Seller'],
      contents: ['Balloons', 'Cake Candles', 'Party Poppers', 'Photo Frame'],
    ),
    HamperProduct(
      id: '5', name: 'Romantic Rose Hamper', emoji: '🌹',
      description: 'Fresh red roses, luxury perfume & silk chocolates for your special someone.',
      price: 3499, oldPrice: 4499, rating: 4.9, reviews: 524,
      category: 'Anniversary', tags: ['Premium', 'Trending'],
      contents: ['Red Roses', 'Premium Perfume', 'Silk Chocolates', 'Love Letter Kit'],
    ),
    HamperProduct(
      id: '6', name: 'Spa Relaxation Box', emoji: '🧖',
      description: 'Organic bath bombs, essential oils & scented candles for ultimate relaxation.',
      price: 2799, oldPrice: 3599, rating: 4.7, reviews: 203,
      category: 'Luxury', tags: ['Popular'],
      contents: ['Bath Bombs', 'Essential Oils', 'Face Mask', 'Scented Candles'],
    ),
    HamperProduct(
      id: '7', name: 'Baby Shower Hamper', emoji: '👶',
      description: 'Adorable baby clothes, soft toys & organic baby care products.',
      price: 2199, oldPrice: 2999, rating: 4.8, reviews: 167,
      category: 'Baby Shower', tags: ['New'],
      contents: ['Baby Clothes', 'Soft Toys', 'Baby Care Kit', 'Memory Book'],
    ),
    HamperProduct(
      id: '8', name: 'Wedding Bliss Hamper', emoji: '💒',
      description: 'Elegant couple gifts, premium dry fruits & decorative items for newlyweds.',
      price: 4999, oldPrice: 6499, rating: 4.9, reviews: 89,
      category: 'Wedding', tags: ['Premium', 'Exclusive'],
      contents: ['Couple Mugs', 'Dry Fruits', 'Photo Album', 'Decor Items'],
    ),
    HamperProduct(
      id: '9', name: 'Gourmet Snack Tower', emoji: '🧁',
      description: 'Multi-tier tower of artisan cheese, crackers, nuts & premium jams.',
      price: 3299, rating: 4.6, reviews: 132,
      category: 'Luxury', tags: ['Exclusive'],
      contents: ['Artisan Cheese', 'Crackers', 'Mixed Nuts', 'Premium Jams'],
    ),
    HamperProduct(
      id: '10', name: 'Valentine Special', emoji: '💕',
      description: 'Heart-shaped chocolates, teddy bear & red roses for your Valentine.',
      price: 2699, oldPrice: 3499, rating: 4.8, reviews: 412,
      category: 'Valentine', tags: ['Limited Edition'],
      contents: ['Heart Chocolates', 'Teddy Bear', 'Red Roses', 'Love Card'],
    ),
  ];

  List<HamperProduct> get trendingProducts =>
      allProducts.where((p) => p.tags.contains('Trending') || p.tags.contains('Best Seller')).toList();

  List<HamperProduct> get bestSellers =>
      allProducts.where((p) => p.tags.contains('Best Seller')).toList();

  List<HamperProduct> get newArrivals =>
      allProducts.where((p) => p.tags.contains('New')).toList();

  List<HamperProduct> productsByCategory(String category) =>
      allProducts.where((p) => p.category == category).toList();

  // ── Favorites / Wishlist ──
  void toggleFavorite(String productId) {
    final product = allProducts.firstWhere((p) => p.id == productId);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  List<HamperProduct> get wishlist => allProducts.where((p) => p.isFavorite).toList();

  // ── Cart ──
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double get cartSubtotal => _cart.fold(0, (sum, item) => sum + item.total);
  double get cartDelivery => _cart.isEmpty ? 0 : 99;
  double get cartDiscount => cartSubtotal * 0.1;
  double get cartTotal => cartSubtotal - cartDiscount + cartDelivery;
  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  String? _appliedCoupon;
  String? get appliedCoupon => _appliedCoupon;

  void addToCart(HamperProduct product) {
    final existing = _cart.where((item) => item.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartQuantity(String productId, int qty) {
    final item = _cart.firstWhere((i) => i.product.id == productId);
    if (qty <= 0) {
      removeFromCart(productId);
    } else {
      item.quantity = qty;
      notifyListeners();
    }
  }

  void applyCoupon(String code) {
    _appliedCoupon = code;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  // ── Custom Hamper ──
  CustomHamperSelection customHamper = CustomHamperSelection();

  void updateCustomHamper(void Function(CustomHamperSelection) updater) {
    updater(customHamper);
    notifyListeners();
  }

  void resetCustomHamper() {
    customHamper = CustomHamperSelection();
    notifyListeners();
  }

  // ── Orders ──
  final List<Order> _orders = [];
  List<Order> get orders => _orders;

  void placeOrder() {
    if (_cart.isEmpty) return;
    _orders.insert(
      0,
      Order(
        id: 'WI-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        items: List.from(_cart),
        total: cartTotal,
      ),
    );
    clearCart();
    notifyListeners();
  }
}
