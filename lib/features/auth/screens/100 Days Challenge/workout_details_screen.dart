import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/workout_models.dart';
import '../../../../core/utils/app_colors.dart';
import 'active_workout_screen.dart';
import 'exercise_detail_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroFade;
  late AnimationController _contentController;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _heroFade =
        CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _contentController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentController, curve: Curves.easeOut));

    _heroController.forward().then((_) => _contentController.forward());
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.workout;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildHeroAppBar(w),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SlideTransition(
                        position: _contentSlide,
                        child: FadeTransition(
                          opacity: _contentController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 32),
                              ...w.phases
                                  .map((phase) => _buildPhaseSection(phase)),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            _buildInitiateButton(context, w),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroAppBar(Workout w) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios,
              color: AppColors.primary, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: FadeTransition(
          opacity: _heroFade,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                w.heroImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, _) => Container(
                  color: AppColors.surfaceContainerHigh,
                  child: const Icon(Icons.fitness_center,
                      color: AppColors.primary, size: 80),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.7),
                      AppColors.background,
                    ],
                    stops: const [0.3, 0.75, 1.0],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.background.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: AppColors.primary,
                      child: Text(
                        w.level,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.onPrimaryFixed,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                          letterSpacing: -2,
                        ),
                        children: [
                          TextSpan(
                            text: '${w.title}\n',
                            style: const TextStyle(
                                color: AppColors.onSurface),
                          ),
                          TextSpan(
                            text: w.subtitle,
                            style: const TextStyle(
                              color: AppColors.primary,
                              shadows: [
                                Shadow(
                                  color: Color(0x998EFF71),
                                  blurRadius: 16,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem('Duration', '${w.durationMinutes}', 'MIN'),
                        _buildDivider(),
                        _buildStatItem('Calories', '${w.calories}', 'KCAL'),
                        _buildDivider(),
                        _buildStatItem(
                            'Exercises', '${w.totalExercises}', 'UNITS'),
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
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.onSurfaceVariant,
            fontSize: 9,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: value,
                  style: const TextStyle(color: AppColors.onSurface)),
              const TextSpan(text: ' '),
              TextSpan(
                  text: unit,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.outlineVariant.withValues(alpha: 0.4),
    );
  }

  Widget _buildPhaseSection(WorkoutPhase phase) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PHASE ${phase.phaseNumber}',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phase.title,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${phase.exercises.length} EXERCISES',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 9,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...phase.exercises.asMap().entries.map(
                (entry) => _buildExerciseCard(entry.value, entry.key),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int index) {
    final offset = index.isEven ? 0.0 : 8.0;
    return Transform.translate(
      offset: Offset(index % 3 == 1 ? offset : -offset / 2, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exercise),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: Image.network(
                          exercise.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, _) => Container(
                            color: AppColors.surfaceContainerHigh,
                            child: const Icon(Icons.fitness_center,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                exercise.name,
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.bolt,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (exercise.duration != null)
                                _buildTag(Icons.timer_outlined, exercise.duration!),
                              if (exercise.reps != null)
                                _buildTag(Icons.repeat, '${exercise.reps} Reps'),
                              if (exercise.sets != null)
                                _buildTag(Icons.layers_outlined, '${exercise.sets} Sets'),
                              if (exercise.weight != null)
                                _buildTag(Icons.fitness_center, exercise.weight!),
                              if (exercise.focusLevel != null)
                                _buildTag(Icons.psychology_outlined, exercise.focusLevel!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right,
                        color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitiateButton(BuildContext context, Workout w) {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActiveWorkoutScreen(workout: w),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'INITIATE PROTOCOL',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.onPrimaryFixed,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.play_arrow,
                    color: AppColors.onPrimaryFixed, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}