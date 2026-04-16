import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'challenge_dashboard_screen.dart';



class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const KineticHomePage();
  }
}

// ── Colour tokens (Local Override) ─────────────────────────────────────────────
const kSecContainer     = Color(0xFF1D4F43);

// ═════════════════════════════════════════════════════════════════════════════
//  HOME PAGE
// ═════════════════════════════════════════════════════════════════════════════
class KineticHomePage extends StatefulWidget {
  const KineticHomePage({super.key});
  @override
  State<KineticHomePage> createState() => _KineticHomePageState();
}

class _KineticHomePageState extends State<KineticHomePage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 1;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _dialog(String title, String subtitle, String body,
      {bool actions = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (_) => _KineticDialog(
        title: title,
        subtitle: subtitle,
        body: body,
        showActions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _hero(),
                  _timeline(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────────
  Widget _topBar() {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 24, right: 24, bottom: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back + brand
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
                  ),
                  _neon('100 DAYS CHALLENGE', 20, FontWeight.bold),
                ]),
                // Phase progres
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('PROTOCOL PHASE: 02',
                      style: TextStyle(
                          fontSize: 10, letterSpacing: 2,
                          color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 96,
                    child: Stack(children: [
                      Container(height: 2, color: AppColors.outlineVariant),
                      Container(
                        height: 2, width: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.7), blurRadius: 6)],
                        ),
                      ),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0x1A8EFF71), Colors.transparent]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ─────────────────────────────────────────────────────────────────────
  Widget _hero() {
    return Container(
      height: 480,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft, radius: 1.2,
          colors: [AppColors.primary.withValues(alpha: 0.08), Colors.transparent],
        ),
      ),
      child: Stack(children: [
        Positioned(
          top: 0, right: 0,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.primary.withValues(alpha: 0.05), Colors.transparent],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(children: [
            _circularProgress(),
            const SizedBox(width: 32),
            Expanded(child: _heroStats()),
          ]),
        ),
      ]),
    );
  }

  Widget _circularProgress() {
    return SizedBox(
      width: 160, height: 160,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(
          size: const Size(160, 160),
          painter: _CirclePainter(progress: 0.70),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          RichText(
            text: const TextSpan(children: [
              TextSpan(
                text: '70',
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold,
                    color: AppColors.onSurface, fontFamily: 'monospace'),
              ),
              TextSpan(
                text: '%',
                style: TextStyle(fontSize: 22, color: AppColors.primary, fontFamily: 'monospace'),
              ),
            ]),
          ),
          const Text('COMPLETE',
              style: TextStyle(fontSize: 9, letterSpacing: 3,
                  color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
        ]),
      ]),
    );
  }

  Widget _heroStats() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(text: const TextSpan(children: [
            TextSpan(
              text: 'HYPER-DASH\n',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                  color: AppColors.onSurface, fontFamily: 'monospace', height: 1.1),
            ),
            TextSpan(
              text: 'PROTOCOL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic, color: AppColors.primary, fontFamily: 'monospace'),
            ),
          ])),
          const SizedBox(height: 12),
          const Text(
            'Elite-level cardiovascular conditioning through high-intensity '
                'asymmetric intervals and biometric optimization.',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 20),
          // Stats row
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0x338EFF71), width: 1)),
            ),
            child: Row(children: [
              _stat('21', 'Completed'),
              const SizedBox(width: 14),
              _stat('09', 'Remaining'),
              const SizedBox(width: 14),
              _stat('+1250', 'TOTAL XP', c: AppColors.primary),
            ]),
          ),
          const SizedBox(height: 20),
          // XP bar
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Next: Level 12 Operative',
                  style: TextStyle(fontSize: 9, letterSpacing: 1.5,
                      color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
              _neon('450 / 600 XP', 9, FontWeight.normal),
            ]),
            const SizedBox(height: 6),
            LayoutBuilder(builder: (ctx, bc) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(children: [
                Container(height: 6, color: AppColors.surfaceContainerHigh),
                Container(
                  height: 6, width: bc.maxWidth * 0.75,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.6), blurRadius: 8)],
                  ),
                ),
              ]),
            )),
          ]),
        ]);
  }

  Widget _stat(String v, String l, {Color c = AppColors.onSurface}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
          color: c, fontFamily: 'monospace')),
      Text(l.toUpperCase(),
          style: const TextStyle(fontSize: 8, letterSpacing: 2,
              color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
    ],
  );

  // ── Timeline ─────────────────────────────────────────────────────────────────
  Widget _timeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(children: [
        Positioned(
          left: 33, top: 0, bottom: 0,
          child: Container(
            width: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0x4D8EFF71), Color(0x1A484847), Colors.transparent],
              ),
            ),
          ),
        ),
        Column(children: [
          _completedDay(),
          const SizedBox(height: 48),
          _activeDay(),
          const SizedBox(height: 48),
          _lockedDay('Day 22 • Strength Matrix', 'ASYMMETRIC LOAD', '45m', 0.4, 1.0),
          const SizedBox(height: 48),
          _badgePreview(),
          const SizedBox(height: 48),
          _lockedDay('Day 23 • Bio-Scan', 'METABOLIC RESET', '', 0.25, 2.0),
        ]),
      ]),
    );
  }

  Widget _completedDay() {
    return GestureDetector(
      onTap: () => _dialog('DAY 20 COMPLETE', 'Recovery Pulse • Neural Reset',
          'Duration: 20 minutes\nStress Level: LOW\n\n'
              'Excellent work completing this recovery session. Your neural '
              'pathways have been reset for optimal performance in the next phase.',
          actions: false),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _node(Icons.check, completed: true),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight, end: Alignment.centerLeft,
                colors: [AppColors.primary.withValues(alpha: 0.05), Colors.transparent],
              ),
              border: const Border(right: BorderSide(color: Color(0x668EFF71), width: 2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _neon('Day 20 • Recovery Pulse', 9, FontWeight.normal, ls: 2),
              const SizedBox(height: 4),
              const Text('NEURAL RESET',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: AppColors.onSurface, fontFamily: 'monospace')),
              const SizedBox(height: 12),
              Row(children: const [
                Icon(Icons.timer_outlined, color: AppColors.onSurfaceVariant, size: 14),
                SizedBox(width: 4),
                Text('20m', style: TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
                SizedBox(width: 16),
                Icon(Icons.bolt_outlined, color: AppColors.onSurfaceVariant, size: 14),
                SizedBox(width: 4),
                Text('LOW STRESS', style: TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _activeDay() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Pulsing node
      AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) => Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [BoxShadow(
              color: AppColors.primary.withOpacity(0.4 + _pulse.value * 0.3),
              blurRadius: 8 + _pulse.value * 10,
              spreadRadius: 2,
            )],
          ),
          child: const Icon(Icons.play_arrow, color: AppColors.onPrimaryFixed, size: 22),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: GestureDetector(
          onTap: () => _dialog('PHASE 02 • DAY 21', 'Kinetic Overload',
              'Maximum capacity interval sprint clusters with reactive '
                  'agility markers.\n\nTarget HR: 175 BPM\n\nThis protocol pushes '
                  'your cardiovascular system to peak performance through asymmetric '
                  'load distribution and reactive agility training.'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
            ),
            child: Stack(children: [
              Positioned(
                top: 0, right: 0,
                child: Icon(Icons.fitness_center, size: 80,
                    color: AppColors.onSurface.withValues(alpha: 0.08)),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _neon('Phase 02 • Day 21', 9, FontWeight.normal, ls: 3),
                    const SizedBox(height: 4),
                    const Text('KINETIC \nOVERLOAD',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                            color: AppColors.onSurface, fontFamily: 'monospace')),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: AppColors.primary,
                    child: const Text('CURRENT',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold,
                            color: AppColors.onPrimaryFixed, fontFamily: 'monospace', letterSpacing: 1)),
                  ),
                ]),
                const SizedBox(height: 12),
                const Text(
                  'Maximum capacity interval sprint clusters with reactive '
                      'agility markers. Target HR: 175 BPM.',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, height: 1.5),
                ),
                const SizedBox(height: 24),
                Column(
                    children: [
                  _btn('Start Protocol', filled: true, onTap: () => _dialog(
                    'INITIATING PROTOCOL', 'Kinetic Overload — Day 21',
                    'Preparing your session:\n\n'
                        '• Warm-up: 5 min dynamic stretch\n'
                        '• Sprint Clusters: 8 × 30s at max effort\n'
                        '• Recovery: 90s between clusters\n'
                        '• Cool-down: 5 min walk\n\n'
                        'Target Heart Rate: 175 BPM\n'
                        'Estimated Calories: 420 kcal\n\nReady to begin?',
                  )),
                  const SizedBox(height: 12),
                  _btn('Briefing', filled: false, onTap: () => _dialog(
                    'MISSION BRIEFING', 'Day 21 — Kinetic Overload',
                    'Protocol Overview:\n\n'
                        'KINETIC OVERLOAD is an elite-tier HIIT session designed '
                        'for maximum cardiovascular output.\n\n'
                        'Objectives:\n'
                        '• Peak VO2 Max stress\n'
                        '• Lactate threshold improvement\n'
                        '• Neuromuscular adaptation\n'
                        '• Mental fortitude training\n\n'
                        'Equipment: Track or flat surface\nDifficulty: ELITE',
                    actions: false,
                  )),
                ]),
              ]),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _btn(String label, {required bool filled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          border: filled ? null : Border.all(color: AppColors.outlineVariant),
          boxShadow: filled
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16)]
              : null,
        ),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.bold,
                color: filled ? AppColors.onPrimaryFixed : AppColors.onSurface,
                fontFamily: 'monospace', letterSpacing: 2)),
      ),
    );
  }

  Widget _lockedDay(String tag, String title, String dur, double opacity, double blur) {
    return GestureDetector(
      onTap: () => _dialog('LOCKED', title,
          'This session is locked. Complete the current protocol to '
              'unlock $title.\n\nKeep pushing to unlock this content.',
          actions: false),
      child: Opacity(
        opacity: opacity,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _node(Icons.lock, completed: false),
          const SizedBox(width: 16),
          Expanded(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.surfaceContainerLow,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tag.toUpperCase(),
                      style: const TextStyle(fontSize: 9, letterSpacing: 2,
                          color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
                  const SizedBox(height: 4),
                  Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: AppColors.onSurface, fontFamily: 'monospace')),
                  if (dur.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(children: [
                      const Icon(Icons.timer_outlined, color: AppColors.onSurfaceVariant, size: 14),
                      const SizedBox(width: 4),
                      Text(dur, style: const TextStyle(fontSize: 9,
                          color: AppColors.onSurfaceVariant, fontFamily: 'monospace')),
                    ]),
                  ],
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _badgePreview() {
    return GestureDetector(
      onTap: () => _dialog('KINETIC VANGUARD', 'Achievement Badge',
          'Complete 2 more sessions to unlock the KINETIC VANGUARD badge.\n\n'
              'This prestigious badge marks you as an elite operative who has '
              'mastered the asymmetric interval protocol.\n\n'
              'Unlocks at: Day 23 completion\nXP Bonus: +500 XP\nStatus: PENDING',
          actions: false),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            color: AppColors.background.withOpacity(0.9),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 32, spreadRadius: 4)],
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppColors.primary.withOpacity(0.15), Colors.transparent],
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
              child: const Icon(Icons.workspace_premium, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _neon('Unlock in 2 Days', 9, FontWeight.normal, ls: 2),
              const Text('KINETIC VANGUARD',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                      color: AppColors.onSurface, fontFamily: 'monospace')),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _node(IconData icon, {required bool completed}) {
    final c = completed ? AppColors.primary : AppColors.outlineVariant;
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        border: Border.all(color: c, width: 2),
        boxShadow: completed
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.45), blurRadius: 12)]
            : null,
      ),
      child: Icon(icon, color: c, size: 14),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────────────
  Widget _bottomNav() {
    const items = [
      (Icons.bolt,                  'PULSE'),
      (Icons.fitness_center,        'PROTOCOLS'),
      (Icons.monitor_heart_outlined,'BIO'),
      (Icons.group_outlined,        'SOCIAL'),
      (Icons.biotech_outlined,      'LAB'),
    ];
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: const Border(top: BorderSide(color: Color(0x33484847))),
        boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 32, offset: Offset(0, -4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _navIndex = i);
              if (i != 1) {
                _dialog(items[i].$2, 'Navigation Tab',
                    'The ${items[i].$2} section would open here in a full app.',
                    actions: false);
              }
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(items[i].$1,
                  color: sel ? AppColors.primary : AppColors.onSurfaceVariant.withOpacity(0.5), size: 24),
              const SizedBox(height: 4),
              Text(items[i].$2,
                  style: TextStyle(fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace',
                      color: sel ? AppColors.primary : AppColors.onSurfaceVariant.withOpacity(0.5))),
              if (sel) ...[
                const SizedBox(height: 4),
                Container(width: 4, height: 4,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
              ],
            ]),
          );
        }),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  Widget _neon(String text, double size, FontWeight weight, {double ls = 0}) {
    return Text(text,
        style: TextStyle(
            fontSize: size, fontWeight: weight,
            color: AppColors.primary, fontFamily: 'monospace', letterSpacing: ls,
            shadows: [Shadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 12)]));
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  CIRCULAR PROGRESS PAINTER
// ═════════════════════════════════════════════════════════════════════════════
class _CirclePainter extends CustomPainter {
  final double progress;
  const _CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 6;

    // Track
    canvas.drawCircle(c, r,
        Paint()
          ..color = kSecContainer.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);

    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(_CirclePainter o) => o.progress != progress;
}

// ═════════════════════════════════════════════════════════════════════════════
//  DIALOG WIDGET
// ═════════════════════════════════════════════════════════════════════════════
class _KineticDialog extends StatelessWidget {
  final String title, subtitle, body;
  final bool showActions;

  const _KineticDialog({
    required this.title,
    required this.subtitle,
    required this.body,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 2)],
        ),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.1), Colors.transparent],
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: AppColors.primary, fontFamily: 'monospace', letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant,
                          fontFamily: 'monospace', letterSpacing: 1.5)),
                ]),
              ),
              Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.4)),
              // Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(body,
                    style: const TextStyle(fontSize: 12, color: AppColors.onSurface,
                        height: 1.7, fontFamily: 'monospace')),
              ),
              // Actions
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: showActions
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (showActions)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12)],
                          ),
                          child: const Text('INITIATE',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                                  color: AppColors.onPrimaryFixed, fontFamily: 'monospace', letterSpacing: 2)),
                        ),
                      ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: const Text('DISMISS',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                                color: AppColors.onSurface, fontFamily: 'monospace', letterSpacing: 2)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}