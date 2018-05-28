const sketch = function(p) {
    let canvas, attractor;
    const sketchWidth = window.innerWidth;
    const sketchHeight = window.innerHeight;
    const movers = [];
    const slices = [];

    p.preload = function() {
        for (let i = 0; i < 19; i++) {
            slices.push(p.loadImage(`./p5js/img/slice-${i}.png`));
        }
    };

    p.mouseClicked = function(e) {
        movers.forEach(mover => {
            mover.location.x = p.random(p.width);
            mover.location.y = p.random(p.height);
        });
    };

    p.setup = function() {
        canvas = p.createCanvas(sketchWidth, sketchHeight);
        canvas.parent('sketch');
        attractor = new Attractor(this);
        for (let i = 0; i < 300; i++) {
            movers.push(
                new Mover(
                    this,
                    p.random(1),
                    p.createVector(p.random(p.width), p.random(p.height)),
                    p.random(1),
                    Math.floor(Math.random() * slices.length)
                )
            );
        }
    };

    p.draw = function() {
        movers.forEach(mover => {
            mover.applyForce(attractor.attract(mover));
            mover.update();
            p.push();
            p.translate(mover.location.x, mover.location.y);
            p.rotate(mover.velocity.heading() + mover.rotationSeed);
            let slice = slices[mover.sliceIndex];
            p.image(
                slice,
                0,
                0,
                slice.width * mover.radius,
                slice.height * mover.radius
            );
            p.pop();
        });
        attractor.updateLocation(p.createVector(p.mouseX, p.mouseY));
    };
};

const myp5 = new p5(sketch);
