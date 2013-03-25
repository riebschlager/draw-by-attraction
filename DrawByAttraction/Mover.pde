public class Mover {

  PVector location, velocity, acceleration;
  float mass, dragC, alpha, distance, radius;

  Mover(float _mass, PVector _location, float _dragC) {
    mass = _mass;
    location = _location;
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector(0, 0);
    dragC = _dragC;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void applyDrag() {
    float speed = velocity.mag();
    float dragMagnitude = dragC * speed * speed;
    PVector drag = velocity.get();
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMagnitude);
    acceleration.add(drag);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    applyDrag();
    distance = dist(mouseX, mouseY, location.x, location.y);
    radius = mass * map(distance, 0, 300, 0, 2);
    if (distance < 10) velocity.mult(0);
  }

  void checkEdges() {
    if (location.x > width) {
      velocity.x = -velocity.x;
    }
    if (location.x < 0) {
      velocity.x = -velocity.x;
    }
    if (location.y < 0) {
      velocity.y = -velocity.y;
    }
    if (location.y > height) {
      velocity.y = -velocity.y;
    }
  }
}

