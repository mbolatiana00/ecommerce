import 'package:ecommerce/core/network/formatter_ariary.dart';
import 'package:ecommerce/core/theme/ecommerce_theme.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/page_widgets.dart';
import '../../../auth/presentation/widgets/auth_button.dart';

import '../../../home/presentation/providers/home_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _qty = 1;

  Widget _circleBtn(IconData icon, VoidCallback onTap, {Color? color}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color ?? const Color(0xFF2D2D3A)),
        ),
      );

  void _add() {
    ref.read(cartProvider.notifier).add(widget.product.id, _qty);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} ajouté au panier'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Voir',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isFav = ref.watch(favoritesProvider.select((f) => f.contains(p.id)));
    final cartCount = ref.watch(cartCountProvider);
    final discount = p.discountPercent;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: Container(
              color: AppTheme.primary.withValues(alpha: 0.12),
              alignment: Alignment.center,
              child: p.hasImage
                  ? Image.network(
                      p.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(p.icon, size: 150, color: AppTheme.primary),
                    )
                  : Icon(p.icon, size: 150, color: AppTheme.primary),
            ),
          ),
          Positioned.fill(
            top: 310,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 20, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                            p.reviewsCount > 0
                                ? '${p.rating}  ·  ${p.reviewsCount} avis'
                                : '${p.rating}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade700)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatAr(p.price),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary)),
                        if (p.oldPrice != null) ...[
                          const SizedBox(width: 10),
                          Text(formatAr(p.oldPrice!),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE11D48),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('-$discount%',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                    if (p.description.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        p.description,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey.shade700),
                      ),
                    ],
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Quantité',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        QtyStepper(
                          qty: _qty,
                          onMinus: () =>
                              setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                          onPlus: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(Icons.arrow_back_ios_new_rounded,
                      () => Navigator.maybePop(context)),
                  Row(
                    children: [
                      _circleBtn(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        () => ref.read(favoritesProvider.notifier).toggle(p.id),
                        color: isFav ? const Color(0xFFE11D48) : null,
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _circleBtn(Icons.shopping_cart_outlined,
                              () => Navigator.pushNamed(context, '/cart')),
                          if (cartCount > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFE11D48),
                                    shape: BoxShape.circle),
                                child: Text('$cartCount',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: AuthButton(
            label: 'Ajouter au panier · ${formatAr(p.price * _qty)}',
            onPressed: _add,
          ),
        ),
      ),
    );
  }
}
