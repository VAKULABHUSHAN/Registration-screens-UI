import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/workout_models.dart';
import '../../../../core/utils/app_colors.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const ActiveWorkoutScreen({super.key, required this.workout});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  int _elapsedSeconds = 0;
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  int _restCountdown = 60;
  Timer? _restTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<Exercise> get _allExercises =>
      widget.workout.phases.expand((p) => p.exercises).toList();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  String get _formattedTime {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _completeExercise() {
    final exercises = _allExercises;
    if (_currentExerciseIndex < exercises.length) {
      setState(() {
        exercises[_currentExerciseIndex].isCompleted = true;
      });
      if (_currentExerciseIndex < exercises.length - 1) {
        _startRestPeriod();
      } else {
        _finishWorkout();
      }
    }
  }

  void _startRestPeriod() {
    setState(() {
      _isResting = true;
      _restCountdown = 60;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_restCountdown > 0) {
          _restCountdown--;
        } else {
          t.cancel();
          _isResting = false;
          _currentExerciseIndex++;
        }
      });
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
      _currentExerciseIndex++;
    });
  }

  void _finishWorkout() {
    _timer.cancel();
    _restTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildCompletionDialog(ctx),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _restTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _allExercises;
    final currentExercise = _currentExerciseIndex < exercises.length
        ? exercises[_currentExerciseIndex]
        : null;
    final progress = ((_currentExerciseIndex) / exercises.length).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progress),
            Expanded(
              child: _isResting
                  ? _buildRestScreen()
                  : _buildExerciseScreen(currentExercise, exercises),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: const Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
                onPressed: () => _confirmExit(),
              ),
              Text(
                _formattedTime,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_currentExerciseIndex}/${_allExercises.length}',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'REST',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 20),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
              child: Center(
                child: Text(
                  '$_restCountdown',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.primary,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (_currentExerciseIndex + 1 < _allExercises.length)
            Column(
              children: [
                Text(
                  'UP NEXT',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _allExercises[_currentExerciseIndex + 1].name,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _skipRest,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'SKIP REST',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseScreen(Exercise? exercise, List<Exercise> allExercises) {
    if (exercise == null) return const SizedBox();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    exercise.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.fitness_center,
                          color: AppColors.primary, size: 60),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXERCISE ${_currentExerciseIndex + 1}',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.primary,
                            fontSize: 10,
                            letterSpacing: 4,
                          ),
                        ),
                        Text(
                          exercise.name,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (exercise.duration != null)
                _buildStatChip(Icons.timer_outlined, exercise.duration!),
              if (exercise.reps != null)
                _buildStatChip(Icons.repeat, '${exercise.reps} Reps'),
              if (exercise.sets != null)
                _buildStatChip(Icons.layers_outlined, '${exercise.sets} Sets'),
              if (exercise.weight != null)
                _buildStatChip(Icons.fitness_center, exercise.weight!),
              if (exercise.focusLevel != null)
                _buildStatChip(Icons.psychology_outlined, exercise.focusLevel!),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _completeExercise,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MARK COMPLETE',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.onPrimaryFixed,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.onPrimaryFixed),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'REMAINING EXERCISES',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          ...allExercises.asMap().entries.map((entry) {
            final i = entry.key;
            final ex = entry.value;
            final isCurrent = i == _currentExerciseIndex;
            final isDone = ex.isCompleted;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? AppColors.primary
                          : isCurrent
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerHighest,
                    ),
                    child: Icon(
                      isDone ? Icons.check : Icons.circle_outlined,
                      size: 14,
                      color: isDone
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    ex.name,
                    style: GoogleFonts.spaceGrotesk(
                      color: isDone
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                      fontSize: 13,
                      fontWeight:
                      isCurrent ? FontWeight.bold : FontWeight.normal,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionDialog(BuildContext ctx) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.check, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'PROTOCOL\nCOMPLETE',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formattedTime,
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.workout.calories} KCAL BURNED',
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FINISH',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.onPrimaryFixed,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(
          'Exit Protocol?',
          style: GoogleFonts.spaceGrotesk(color: AppColors.onSurface),
        ),
        content: Text(
          'Your progress will be lost.',
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL',
                style: GoogleFonts.spaceGrotesk(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('EXIT',
                style: GoogleFonts.spaceGrotesk(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}