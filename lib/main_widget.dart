import 'package:ecommerce/core/route/go_router_provider.dart';
import 'package:ecommerce/core/theme/ecommerce_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainWidget extends ConsumerWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return  MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: goRouter,
    );
  }
}
