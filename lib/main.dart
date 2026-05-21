import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/ingestion/presentation/ingestion_screen.dart';
import 'features/agent_trace/presentation/agent_trace_screen.dart';
import 'features/action_hub/presentation/action_hub_screen.dart';
import 'features/dashboard/presentation/campaigns_screen.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local database
  await Hive.initFlutter();
  
  runApp(const ProviderScope(child: TezAdsApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/ingestion',
        builder: (context, state) => const IngestionScreen(),
      ),
      GoRoute(
        path: '/trace',
        builder: (context, state) => const AgentTraceScreen(),
      ),
      GoRoute(
        path: '/action',
        builder: (context, state) => const ActionHubScreen(),
      ),
      GoRoute(
        path: '/campaigns',
        builder: (context, state) => const CampaignsScreen(),
      ),
    ],
  );
});

class TezAdsApp extends ConsumerWidget {
  const TezAdsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'TezAds',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
