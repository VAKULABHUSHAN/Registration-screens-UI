import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/app_colors.dart';

import 'challenge_details_screen.dart';




class ChallengeHub extends StatefulWidget {
  const ChallengeHub({super.key});
  @override
  State<ChallengeHub> createState() => _ChallengeHubState();
}

class _ChallengeHubState extends State<ChallengeHub> {
  int _selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          // Radial gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -1.4),
                radius: 1.5,
                colors: [Color(0xFF1A2E16), AppColors.background],
                stops: [0.0, 0.55],
              ),
            ),
          ),
          const _ParticleLayer(),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _KineticAppBar(),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _GreetingSection(),
                    const SizedBox(height: 40),
                    const _DaySelectorSection(),
                    const SizedBox(height: 40),
                    const _QuickInsightsSection(),
                    const SizedBox(height: 40),
                    const _ActiveProtocolsSection(),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 96,
            right: 24,
            child: _NeonFAB(),
          ),
        ],
      ),
      // bottomNavigationBar: _BottomNav(
      //   selectedIndex: _selectedNav,
      //   onTap: (i) => setState(() => _selectedNav = i),
      // ),
    );
  }
}

// ═══════════════════════════════════════════════
//  APP BAR DELEGATE
// ═══════════════════════════════════════════════
class _KineticAppBar extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF09090A).withOpacity(0.45),
            border: const Border(
              bottom: BorderSide(color: Color(0x1A8EFF71), width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHighest,
                        border: Border.all(
                            color: AppColors.outlineVariant.withOpacity(0.2)),
                      ),
                      child: const ClipOval(child: _AvatarWidget()),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'KINETIC',
                      style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary).copyWith(
                        letterSpacing: 4,
                        shadows: const [
                          Shadow(color: Color(0x668EFF71), blurRadius: 8)
                        ],
                      ),
                    ),
                  ]),
                  const Icon(Icons.settings_input_antenna,
                      color: AppColors.primary, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => false;
}

// ═══════════════════════════════════════════════
//  GREETING + PROGRESS RING
// ═══════════════════════════════════════════════
class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'System Status: Optimal',
              style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                  .copyWith(letterSpacing: 4),
            ),
            const SizedBox(height: 4),
            Text('Good Evening,\nChampion 👋', style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            const SizedBox(height: 4),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔥 STREAK',
                            style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurface).copyWith(
                              letterSpacing: 2,
                              color: AppColors.primary.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '12 DAYS',
                            style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: AppColors.primary.withOpacity(0.8),
                                  blurRadius: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
            ),
          ]),

        ],
      ),

      const SizedBox(height: 40),
      SizedBox(
        width: 224,
        height: 224,
        child: CustomPaint(
          painter: _ProgressRingPainter(progress: 0.70),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Daily Load',
                  style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                      .copyWith(letterSpacing: 4)),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  text: '72',
                  style: GoogleFonts.spaceGrotesk(fontSize: 54, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  children: [
                    TextSpan(
                        text: '%',
                        style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary))
                  ],
                ),
              ),
              Text('Bio-Efficiency',
                  style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                      .copyWith(letterSpacing: 4)),
            ]),
          ),
        ),
      ),
    ]);
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  const _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0x331D4F43)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0,
    );
    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════
//  DAY SELECTOR
// ═══════════════════════════════════════════════
class _DaySelectorSection extends StatelessWidget {
  const _DaySelectorSection();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Training Protocol',
              style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                  .copyWith(letterSpacing: 4)),
          Text('WEEK 04',
              style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary).copyWith(letterSpacing: 2)),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, i) {
            final DayStatus s;
            if (i < 2) {
              s = DayStatus.done;
            } else if (i == 2) {
              s = DayStatus.active;
            } else {
              s = DayStatus.upcoming;
            }
            return _DayCard(label: 'D${i + 1}', status: s);
          },
        ),
      ),
    ]);
  }
}

enum DayStatus { done, active, upcoming }

class _DayCard extends StatefulWidget {
  final String label;
  final DayStatus status;
  const _DayCard({required this.label, required this.status});
  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (widget.status == DayStatus.active) _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.status == DayStatus.done;
    final isActive = widget.status == DayStatus.active;

    return Opacity(
      opacity: isDone ? 0.4 : 1.0,
      child: Container(
        width: 54,
        height: 88,
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.outlineVariant.withOpacity(isDone ? 0.1 : 0.05),
          ),
          boxShadow: isActive
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 15)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.label,
                style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
            const SizedBox(height: 6),
            if (isDone)
              Icon(Icons.check_circle,
                  color: AppColors.primary.withOpacity(0.4), size: 18)
            else if (isActive) ...[
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(_anim.value)),
                ),
              ),
              const SizedBox(height: 4),
              Text('Active',
                  style: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.onSurface).copyWith(letterSpacing: 1)),
            ] else
              Text('0%', style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.outline)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  QUICK INSIGHTS ROW
// ═══════════════════════════════════════════════
class _QuickInsightsSection extends StatelessWidget {
  const _QuickInsightsSection();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: _InsightCard(
              icon: Icons.local_fire_department, value: '1,240', unit: 'KCAL')),
      const SizedBox(width: 16),
      Expanded(
          child: _InsightCard(icon: Icons.schedule, value: '42m', unit: 'ACTIVE')),
      const SizedBox(width: 16),
      Expanded(
          child: _InsightCard(
              icon: Icons.military_tech, value: '850', unit: 'XP GAIN')),
    ]);
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  const _InsightCard(
      {required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
      ),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 2),
        Text(unit,
            style:
            GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant).copyWith(letterSpacing: 3)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════
//  ACTIVE PROTOCOLS
// ═══════════════════════════════════════════════
class _ActiveProtocolsSection extends StatelessWidget {
  const _ActiveProtocolsSection();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Active Protocols', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text('Browse All',
              style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)
                  .copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary.withOpacity(0.3),
              )),
        ],
      ),
      const SizedBox(height: 24),
      GestureDetector(
        child:
        _ChallengeCard(
          title: 'Hyper-Trophy Blast',
          subtitle: 'Neural adaptation & muscular fatigue focus.',
          badge: 'ELITE',
          badgeHighlight: true,
          progress: 0.85,
          progressLabel: '85%',
          progressHighlight: true,
          participants: const ['JD', 'MK', '+12'],
          actionLabel: 'Continue',
          isActive: true,
          thumbnailIcon: Icons.fitness_center,
          thumbnailColor: const Color(0xFF2B3D27),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChallengeDetailsScreen(),
            ),
          );
        },
      ),
      const SizedBox(height: 24),
      _ChallengeCard(
        title: 'Neuro-Stability Phase',
        subtitle: 'Proprioception and core alignment protocol.',
        badge: 'CORE',
        badgeHighlight: false,
        progress: 0.12,
        progressLabel: '12%',
        progressHighlight: false,
        participants: const [],
        actionLabel: 'Initialize',
        isActive: false,
        thumbnailIcon: Icons.self_improvement,
        thumbnailColor: AppColors.surfaceContainerHigh,
        bottomExtra: '320 XP Remaining',
      ),
    ]);
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final bool badgeHighlight;
  final double progress;
  final String progressLabel;
  final bool progressHighlight;
  final List<String> participants;
  final String actionLabel;
  final bool isActive;
  final IconData thumbnailIcon;
  final Color thumbnailColor;
  final String? bottomExtra;

  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeHighlight,
    required this.progress,
    required this.progressLabel,
    required this.progressHighlight,
    required this.participants,
    required this.actionLabel,
    required this.isActive,
    required this.thumbnailIcon,
    required this.thumbnailColor,
    this.bottomExtra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Stack(children: [
        if (isActive)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Stack(children: [
                  Container(
                    width: 80,
                    height: 96,
                    decoration: BoxDecoration(
                      color: thumbnailColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.6,
                        child: Icon(thumbnailIcon,
                            color: AppColors.primary.withOpacity(0.6), size: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: badgeHighlight
                              ? AppColors.primary.withOpacity(0.3)
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: Text(badge,
                          style: GoogleFonts.spaceGrotesk(fontSize: 7, fontWeight: FontWeight.bold,
                              color: badgeHighlight
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant)),
                    ),
                  ),
                ]),
                const SizedBox(width: 20),
                // Content column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.onSurface).copyWith(
                            color: isActive
                                ? AppColors.onSurface
                                : AppColors.onSurface.withOpacity(0.8),
                          )),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress',
                              style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                                  .copyWith(letterSpacing: 3)),
                          Text(progressLabel,
                              style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold,
                                  color: progressHighlight
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressHighlight
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant.withOpacity(0.3),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.surfaceContainerHigh.withOpacity(0.5)
                  : AppColors.surfaceContainerHigh.withOpacity(0.3),
              border: Border(
                  top: BorderSide(
                      color: AppColors.outlineVariant.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (participants.isNotEmpty)
                  _AvatarStack(labels: participants)
                else if (bottomExtra != null)
                  Row(children: [
                    const Icon(Icons.bolt,
                        size: 12, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(bottomExtra!,
                        style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)
                            .copyWith(letterSpacing: 3)),
                  ])
                else
                  const SizedBox.shrink(),
                GestureDetector(
                    child: _ActionButton(label: actionLabel, filled: isActive),
                  onTap: ()=> ChallengeDetailsScreen(),
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final List<String> labels;
  const _AvatarStack({required this.labels});

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.surfaceBright, const Color(0xFF3F3F3F)];
    final w = (labels.length * 18.0 + 10).clamp(0.0, 100.0);
    return SizedBox(
      height: 28,
      width: w,
      child: Stack(
        children: labels.asMap().entries.map((e) {
          final isPlus = e.value.startsWith('+');
          return Positioned(
            left: e.key * 18.0,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPlus
                    ? AppColors.primary.withOpacity(0.2)
                    : colors[e.key % colors.length],
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: Center(
                child: Text(e.value,
                    style: GoogleFonts.spaceGrotesk(fontSize: 6, fontWeight: FontWeight.bold,
                        color: isPlus ? AppColors.primary : AppColors.onSurface)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  const _ActionButton({required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(3),
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        onTap: ()=> ChallengeDetailsScreen(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: filled
              ? null
              : BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(label.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold,
                  color: filled ? AppColors.onPrimaryFixed : AppColors.onSurfaceVariant)
                  .copyWith(letterSpacing: -0.5)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  FAB
// ═══════════════════════════════════════════════
class _NeonFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)
          ],
        ),
        child: const Icon(Icons.add, color: AppColors.onPrimaryFixed, size: 32),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  BOTTOM NAV
// ═══════════════════════════════════════════════
// class _BottomNav extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onTap;
//   const _BottomNav({required this.selectedIndex, required this.onTap});
//
//   static const _items = [
//     _NavItem(icon: Icons.bolt, label: 'PULSE'),
//     _NavItem(icon: Icons.fitness_center, label: 'PROTOCOLS'),
//     _NavItem(icon: Icons.monitor_heart_outlined, label: 'BIO'),
//     _NavItem(icon: Icons.group, label: 'SOCIAL'),
//     _NavItem(icon: Icons.biotech, label: 'LAB'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           height: 80,
//           decoration: const BoxDecoration(
//             color: Color(0xF009090A),
//             border: Border(
//                 top: BorderSide(color: Color(0x80333333), width: 0.5)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: _items.asMap().entries.map((e) {
//               final sel = e.key == selectedIndex;
//               return GestureDetector(
//                 onTap: () => onTap(e.key),
//                 behavior: HitTestBehavior.opaque,
//                 child: AnimatedOpacity(
//                   opacity: sel ? 1.0 : 0.4,
//                   duration: const Duration(milliseconds: 200),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         e.value.icon,
//                         color: sel ? KC.primary : Colors.white,
//                         size: 24,
//                         shadows: sel
//                             ? const [
//                           Shadow(
//                               color: Color(0x998EFF71), blurRadius: 12)
//                         ]
//                             : null,
//                       ),
//                       const SizedBox(height: 3),
//                       Text(e.value.label,
//                           style: KC.label(9,
//                               color: sel ? KC.primary : Colors.white)
//                               .copyWith(letterSpacing: 2)),
//                       if (sel) ...[
//                         const SizedBox(height: 3),
//                         Container(
//                           width: 4,
//                           height: 4,
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: KC.primary),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _NavItem {
//   final IconData icon;
//   final String label;
//   const _NavItem({required this.icon, required this.label});
// }

// ═══════════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════════
class _ParticleLayer extends StatelessWidget {
  const _ParticleLayer();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final positions = [
      Offset(s.width * 0.10, s.height * 0.15),
      Offset(s.width * 0.80, s.height * 0.45),
      Offset(s.width * 0.30, s.height * 0.80),
      Offset(s.width * 0.60, s.height * 0.20),
      Offset(s.width * 0.15, s.height * 0.65),
    ];
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.2,
          child: Stack(
            children: positions.map((p) {
              return Positioned(
                left: p.dx,
                top: p.dy,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.5), blurRadius: 4)
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      child: const Icon(Icons.person, color: AppColors.primary, size: 22),
    );
  }
}