import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Wrapit ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Find the perfect hamper 💕",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.pink,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                hintText: "Search hampers…",
                hintStyle: TextStyle(color: Colors.pink.shade200, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.pink),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.pink.shade200,
                    width: 1.5,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.pink),
                  onPressed: () {
                    // open filter options
                  },
                ),
              ),
              style: const TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(label: "All"),
                    CategoryChip(label: "Birthday"),
                    CategoryChip(label: "Anniversary"),
                    CategoryChip(label: "Festive"),
                    CategoryChip(label: "Corporate"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),

            Text(
              "Featured Hampers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),

            SizedBox(height: 12),

            HamperCard(
              title: "Luxury Chocolate Hamper 🍫",
              description: "Premium chocolates, cookies & wine",
              price: "₹2499",
              sold: "",
            ),
            SizedBox(height: 16),
            HamperCard(
              title: "Festive Delight Hamper 🎉",
              description: "Dry fruits, sweets & candles",
              price: "₹1999",
              sold: "",
            ),
            SizedBox(height: 16),
            HamperCard(
              title: "Corporate Gift Hamper 💼",
              description: "Coffee, planner & gourmet snacks",
              price: "₹2999",
              sold: "",
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.pink.shade100,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class HamperCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String sold;

  const HamperCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.sold,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(sold, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
