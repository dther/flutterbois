// TODO Implement this library.

import 'package:vector_math/vector_math.dart';

class BoidBox {
  /* A 2D toroidal plane containing some number of boids
  with an origin at (0, 0). */
  int numBoids;
  Vector2 dimensions;
  late Aabb2 _box; // bounding box
  late List<Boid> boids;

  BoidBox(this.numBoids, this.dimensions) {
    _box = Aabb2.minMax(Vector2.zero() , this.dimensions);
    boids = List.generate(this.numBoids, newBoid);
  }

  Boid newBoid(int index) {
    // Generate a boid inside the plane.
    return Boid(this);
  }

  containsBoid(Boid boid) {
    // Checks if a boid is outside the bounds of this plane
    return _box.intersectsWithVector2(boid.position);
  }

  moveBoids() {
    // Make all boids move and recalculate their velocities.
    for (Boid boid in boids) {
      boid.move();
      /* Y'know there's probably a smart way to do this,
      but I skipped maths C so here we are
       */
      if (!containsBoid(boid)) {
        if (boid.position.x > _box.max.x) {
          boid.position.x = 0;
        }
        if (boid.position.y > _box.max.y) {
          boid.position.y = 0;
        }
        if (boid.position.x < 0) {
          boid.position.x = _box.max.x;
        }
        if (boid.position.y < 0) {
          boid.position.y = _box.max.y;
        }
      }
    }
  }
}

class Boid {
  late Vector2 position;
  late Vector2 velocity;
  late BoidBox world;

  Boid(BoidBox boidBox) {
    // Create a new boid in a random location within the confines of
    // boidBox, and impart a random normalised velocity.
    this.position = Vector2.random();
    this.position.multiply(boidBox.dimensions);
    this.velocity = (Vector2.random() - Vector2(0.5, 0.5));
    this.velocity.length = 1;
    this.world = boidBox;
  }

  bool canSee(Boid boid) {
    // returns true if the other boid is within view of this boid
    Vector2 distance = (position - boid.position);
    return distance.length < 30;
  }

  move() {
    this.position += this.velocity;
    this.calculateVelocity(null);
  }

  calculateVelocity(List<Vector2>? extraRules) {
    this.velocity += (calculateSeparation()
                      + calculateCohesion()
                      + calculateAlignment());

    if (extraRules != null) {
      for (Vector2 rule in extraRules) {
        this.velocity += rule;
      }
    }
    this.velocity.length = velocity.length > 1 ? 1 : velocity.length;
  }

  Vector2 calculateSeparation() {
    // TODO: this
    Vector2 separation = Vector2.zero();
    for (Boid boid in world.boids) {
      if (boid != this && canSee(boid)) {
        Vector2 distance = (position - boid.position);
        distance.absolute();
        if (distance.length < 25) {
          separation += position - boid.position;
        }
      }
    }
    separation.length = separation.length > 1 ? 1 : separation.length;
    return separation;
  }

  Vector2 calculateCohesion() {
    // TODO: this
    Vector2 cohesion = Vector2.zero();
    double nearBoids = 0;
    for (Boid boid in world.boids) {
      if (boid != this && canSee(boid)) {
        cohesion += boid.position;
        nearBoids++;
      }
    }
    if (nearBoids != 0) {
      cohesion /= nearBoids;
      cohesion -= this.position;
    }
    cohesion.length = cohesion.length > 1 ? 1 : cohesion.length;
    return cohesion;
  }

  Vector2 calculateAlignment() {
    // TODO: this
    Vector2 alignment = Vector2.zero();
    for (Boid boid in world.boids) {
      if (boid != this && canSee(boid)) {
        alignment += boid.velocity;
      }
    }
    alignment.length = alignment.length > 1 ? 1 : alignment.length;
    return alignment;
  }
}