
import 'package:ecommerce/core/route/route_name.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/register_page.dart';
import 'package:ecommerce/features/home/presentation/pages/ProfileScreen.dart';
import 'package:ecommerce/features/home/presentation/pages/SettingsScreen.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce/features/intro/SplashPage.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';
import 'package:ecommerce/features/product/presentation/pages/product_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: "/splash",
        name: SplashRoute,
        builder: (context, state)=> const SplashPage(),
        ),
      GoRoute(
        path: "/home",
        name: HomeRoute,
        builder: (context, state) =>const  HomePage(),
      ),
       GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: "/login",
        name: LoginRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: ProductRoute,
        builder: (context, state) =>
            ProductDetailPage(product: state.extra as Product),
      ),
      GoRoute(
        path: "/profile",
        name: ProfileRoute,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: "/setting",
        name: SettingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
 
    ],
  );
});



