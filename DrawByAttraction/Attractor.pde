public class Attractor {
  float mass, G;
  PVector location;

  Attractor() {
    location = new PVector(width / 2, height / 2);
    mass = 1;
    G = 1;
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location, m.location);
    float d = force.mag();
    m.alpha = map(d, 0, 200, 5, 255);
    d = constrain(d, 1.0, 2.0);
    force.normalize();
    float strength = (G * mass * m.mass) / (d * d);
    force.mult(strength);
    return force;
  }

  void updateLocation(PVector _location) {
    location = _location;
  }
}

