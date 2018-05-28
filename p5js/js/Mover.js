class Mover {
    constructor(p5, mass, location, dragC, sliceIndex) {
        this.p5 = p5;
        this.mass = mass;
        this.location = location;
        this.velocity = p5.createVector(0, 0);
        this.acceleration = p5.createVector(0, 0);
        this.dragC = dragC;
        this.sliceIndex = sliceIndex;
        this.rotationSeed = p5.random(360);
    }
    applyForce(force) {
        let f = p5.Vector.div(force, this.mass);
        this.acceleration.add(f);
    }
    applyDrag() {
        let speed = this.velocity.mag();
        let dragMagnitude = this.dragC * speed * speed;
        let drag = this.velocity.copy();
        drag.mult(-1);
        drag.normalize();
        drag.mult(dragMagnitude);
        this.acceleration.add(drag);
    }
    update() {
        this.velocity.add(this.acceleration);
        this.location.add(this.velocity);
        this.acceleration.mult(0);
        this.applyDrag();
        this.distance = this.p5.dist(
            this.p5.mouseX,
            this.p5.mouseY,
            this.location.x,
            this.location.y
        );
        this.radius =
            this.mass * this.p5.map(this.distance, 0, this.p5.width, 0.1, 1.5);
    }
    checkEdges() {
        if (this.location.x > this.p5.width) {
            this.velocity.x *= -1;
        }
        if (this.location.x < 0) {
            this.velocity.x *= -1;
        }
        if (this.location.y < 0) {
            this.velocity.y *= -1;
        }
        if (this.location.y > this.p5.height) {
            this.velocity.y *= -1;
        }
    }
}
