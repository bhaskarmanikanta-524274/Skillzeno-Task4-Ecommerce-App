import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/app_state.dart';
import 'services/product_service.dart';

void main() {
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartState()),
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Skillzeno Store',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final success = await context.read<AuthState>().login(
          emailController.text,
          passwordController.text,
        );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Icon(Icons.shopping_bag_rounded, size: 64),
                      const SizedBox(height: 10),
                      const Text(
                        'Skillzeno Store',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Login',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => obscure = !obscure);
                            },
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      if (auth.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          auth.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: auth.loading ? null : login,
                          child: auth.loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text('Create a new account'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Demo: demo@skillzeno.com / 123456',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    final success = await context.read<AuthState>().signup(
          emailController.text,
          passwordController.text,
        );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const Icon(Icons.person_add_alt_1, size: 56),
                    const SizedBox(height: 18),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_reset_outlined),
                      ),
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        auth.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: auth.loading ? null : signup,
                        child: auth.loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = ProductService();
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = service.fetchProducts();
  }

  void retry() {
    setState(() => products = service.fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartState>().count;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skillzeno Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Cart',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (count > 0)
                Positioned(
                  right: 7,
                  top: 7,
                  child: CircleAvatar(
                    radius: 9,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 56),
                    const SizedBox(height: 10),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final productList = snapshot.data ?? [];

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 3
                      : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.67,
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) => ProductCard(
                  product: productList[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailsPage(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 45),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, size: 15),
                  Text(' ${product.rating.toStringAsFixed(1)}'),
                  const Spacer(),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    context.read<CartState>().add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Product product;

  const DetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 700;

          final image = Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.network(
              product.image,
              height: wide ? 380 : 280,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 80),
            ),
          );

          final info = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(label: Text(product.category)),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('⭐ ${product.rating.toStringAsFixed(1)} / 5'),
              const SizedBox(height: 14),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.description,
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    context.read<CartState>().add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added to cart')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: image),
                      const SizedBox(width: 28),
                      Expanded(child: info),
                    ],
                  )
                : Column(
                    children: [
                      image,
                      const SizedBox(height: 22),
                      info,
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 70),
                  SizedBox(height: 10),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(
                              item.product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            item.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => context
                                    .read<CartState>()
                                    .dec(item.product),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                ),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () => context
                                    .read<CartState>()
                                    .inc(item.product),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${item.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => context
                                    .read<CartState>()
                                    .remove(item.product),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Order Demo'),
                                  content: Text(
                                    'Order total: \$${cart.total.toStringAsFixed(2)}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  child: Icon(Icons.person, size: 52),
                ),
                const SizedBox(height: 15),
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  auth.email ?? 'Guest',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.shopping_bag_outlined),
                        title: Text('My Orders'),
                        subtitle: Text('View order history'),
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.favorite_border),
                        title: Text('Wishlist'),
                        subtitle: Text('Saved products'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () async {
                          await context.read<AuthState>().logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (_) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
