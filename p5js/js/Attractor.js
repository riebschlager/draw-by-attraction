class Attractor {
    constructor(p5) {
        this.p5 = p5;
        this.mass = 1;
        this.G = 1;
        this.location = p5.createVector(p5.width / 2, p5.height / 2);
    }
    attract(m) {
        let force = p5.Vector.sub(this.location, m.location);
        let d = force.mag();
        m.alpha = this.p5.map(d, 0, 200, 5, 255);
        d = this.p5.constrain(d, 1.0, 2.0);
        force.normalize();
        let strength = this.G * this.mass * m.mass / (d * d);
        force.mult(strength);
        return force;
    }
    updateLocation(location) {
        this.location = location;
    }
}
