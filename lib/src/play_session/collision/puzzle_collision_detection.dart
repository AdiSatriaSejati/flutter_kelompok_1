import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_kelompok_1/src/play_session/collision/PuzzleHitbox.dart';
import 'package:flutter_kelompok_1/src/play_session/jigsaw/piece_component.dart';
import 'package:flutter_kelompok_1/src/play_session/shape_type.dart';

/// Implementasi default dari [CollisionDetection].
/// Memeriksa apakah ada [ShapeHitbox] di [items] yang bertabrakan satu sama lain dan
/// memanggil metode callback mereka sesuai.
///
/// Secara default, [Sweep] broadphase digunakan, ini dapat dikonfigurasi dengan
/// melewatkan [Broadphase] lain ke konstruktor.
class PuzzleCollisionDetection<B extends Broadphase<ShapeHitbox>>
    extends CollisionDetection<ShapeHitbox, B> {
  PuzzleCollisionDetection({B? broadphase})
      : super(broadphase: broadphase ?? Sweep<ShapeHitbox>() as B);

  /// Memeriksa titik-titik perpotongan dari dua collidables,
  /// mengembalikan daftar kosong jika tidak ada perpotongan.
  @override
  Set<Vector2> intersections(
    ShapeHitbox hitboxA,
    ShapeHitbox hitboxB,
  ) {
    return hitboxA.intersections(hitboxB);
  }

  /// Memanggil dua hitbox yang bertabrakan ketika mereka pertama kali mulai bertabrakan.
  /// Mereka dipanggil dengan [intersectionPoints] dan instance satu sama lain,
  /// sehingga mereka dapat menentukan hitbox apa (dan apa
  /// [ShapeHitbox.hitboxParent] yang mereka tabrakan.
  @override
  void handleCollisionStart(
    Set<Vector2> intersectionPoints,
    ShapeHitbox hitboxA,
    ShapeHitbox hitboxB,
  ) {
    if (typeCollision(hitboxA as PuzzleHitbox, hitboxB as PuzzleHitbox)) {
      hitboxA.onCollisionStart(intersectionPoints, hitboxB);
      hitboxB.onCollisionStart(intersectionPoints, hitboxA);
    }
  }

  /// Memanggil dua hitbox yang bertabrakan setiap tick ketika mereka bertabrakan.
  /// Mereka dipanggil dengan [intersectionPoints] dan instance satu sama lain,
  /// sehingga mereka dapat menentukan hitbox apa (dan apa
  /// [ShapeHitbox.hitboxParent] yang mereka tabrakan.
  @override
  void handleCollision(
    Set<Vector2> intersectionPoints,
    ShapeHitbox hitboxA,
    ShapeHitbox hitboxB,
  ) {
    if (typeCollision(hitboxA as PuzzleHitbox, hitboxB as PuzzleHitbox)) {
      hitboxA.onCollision(intersectionPoints, hitboxB);
      hitboxB.onCollision(intersectionPoints, hitboxA);
    }
  }

  /// Memanggil dua hitbox yang bertabrakan sekali ketika dua hitbox berhenti
  /// bertabrakan.
  /// Mereka dipanggil dengan instance satu sama lain, sehingga mereka dapat menentukan
  /// hitbox apa (dan apa [ShapeHitbox.hitboxParent] yang mereka berhenti
  /// bertabrakan.
  @override
  void handleCollisionEnd(ShapeHitbox hitboxA, ShapeHitbox hitboxB) {
    if (typeCollision(hitboxA as PuzzleHitbox, hitboxB as PuzzleHitbox)) {
      hitboxA.onCollisionEnd(hitboxB);
      hitboxB.onCollisionEnd(hitboxA);
    }
  }

  static final _temporaryRaycastResult = RaycastResult<ShapeHitbox>();

  /// Melakukan raycast dan mengembalikan hasil raycast.
  @override
  RaycastResult<ShapeHitbox>? raycast(Ray2 ray,
      {double? maxDistance,
      bool Function(ShapeHitbox candidate)? hitboxFilter,
      List<ShapeHitbox>? ignoreHitboxes,
      RaycastResult<ShapeHitbox>? out}) {
    var finalResult = out?..reset();
    for (final item in items) {
      if (ignoreHitboxes?.contains(item) ?? false) {
        continue;
      }
      final currentResult =
          item.rayIntersection(ray, out: _temporaryRaycastResult);
      final possiblyFirstResult = !(finalResult?.isActive ?? false);
      if (currentResult != null &&
          (possiblyFirstResult ||
              currentResult.distance! < finalResult!.distance!) &&
          (currentResult.distance! <= (maxDistance ?? double.infinity))) {
        if (finalResult == null) {
          finalResult = currentResult.clone();
        } else {
          finalResult.setFrom(currentResult);
        }
      }
    }
    return (finalResult?.isActive ?? false) ? finalResult : null;
  }

  /// Melakukan raycast pada semua hitbox dan mengembalikan hasilnya.
  @override
  List<RaycastResult<ShapeHitbox>> raycastAll(Vector2 origin,
      {required int numberOfRays,
      double startAngle = 0,
      double sweepAngle = tau,
      double? maxDistance,
      List<Ray2>? rays,
      bool Function(ShapeHitbox candidate)? hitboxFilter,
      List<ShapeHitbox>? ignoreHitboxes,
      List<RaycastResult<ShapeHitbox>>? out}) {
    final isFullCircle = (sweepAngle % tau).abs() < 0.0001;
    final angle = sweepAngle / (numberOfRays + (isFullCircle ? 0 : -1));
    final results = <RaycastResult<ShapeHitbox>>[];
    final direction = Vector2(1, 0);
    for (var i = 0; i < numberOfRays; i++) {
      Ray2 ray;
      if (i < (rays?.length ?? 0)) {
        ray = rays![i];
      } else {
        ray = Ray2.zero();
        rays?.add(ray);
      }
      ray.origin.setFrom(origin);
      direction
        ..setValues(0, -1)
        ..rotate(startAngle - angle * i);
      ray.direction = direction;

      RaycastResult<ShapeHitbox>? result;
      if (i < (out?.length ?? 0)) {
        result = out![i];
      } else {
        result = RaycastResult();
        out?.add(result);
      }
      result = raycast(
        ray,
        maxDistance: maxDistance,
        ignoreHitboxes: ignoreHitboxes,
        out: result,
      );

      if (result != null) {
        results.add(result);
      }
    }
    return results;
  }

  /// Melakukan raytrace dan mengembalikan hasilnya.
  @override
  Iterable<RaycastResult<ShapeHitbox>> raytrace(Ray2 ray,
      {int maxDepth = 10,
      bool Function(ShapeHitbox candidate)? hitboxFilter,
      List<ShapeHitbox>? ignoreHitboxes,
      List<RaycastResult<ShapeHitbox>>? out}) sync* {
    out?.forEach((e) => e.reset());
    var currentRay = ray;
    for (var i = 0; i < maxDepth; i++) {
      final hasResultObject = (out?.length ?? 0) > i;
      final storeResult =
          hasResultObject ? out![i] : RaycastResult<ShapeHitbox>();
      final currentResult = raycast(
        currentRay,
        ignoreHitboxes: ignoreHitboxes,
        out: storeResult,
      );
      if (currentResult != null) {
        currentRay = storeResult.reflectionRay!;
        if (!hasResultObject && out != null) {
          out.add(storeResult);
        }
        yield storeResult;
      } else {
        break;
      }
    }
  }

  /// Memeriksa apakah dua hitbox bertabrakan berdasarkan tipe mereka.
  bool typeCollision(PuzzleHitbox hitboxA, PuzzleHitbox hitboxB) {
    if (hitboxA.shapeTab + hitboxB.shapeTab != 0) {
      return false;
    }
    if (hitboxA.type == ShapeType.left && hitboxB.type == ShapeType.right) {
      return true;
    }
    if (hitboxA.type == ShapeType.right && hitboxB.type == ShapeType.left) {
      return true;
    }
    if (hitboxA.type == ShapeType.top && hitboxB.type == ShapeType.bottom) {
      return true;
    }
    if (hitboxA.type == ShapeType.bottom && hitboxB.type == ShapeType.top) {
      return true;
    }
    return false;
  }
}
