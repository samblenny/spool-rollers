
height = 4;

module block() {
    linear_extrude(height,convexity=10)
    union() {
        square([10,30]);
        square([20,20]);
        square([30,10]);
    }
}

// This makes a tool shape to cut a horizontal chamfer
module chamfer(length=32) {
    translate([-1,0,0])
    rotate([0,90,0])
    linear_extrude(length)
    polygon([[-1,0],[0,1],[1,0],[0,-1]]);
}

// This makes a tool shape to cut a vertical chamfer
module v_chamfer() {
    translate([0,0,-1])
    linear_extrude(height+2)
    polygon([[-1,0],[0,1],[1,0],[0,-1]]);
}

// These cut the sharp squares in the inside corners
module inside_corner_wedges(height) {
    union() {
        translate([2,2,height+1]) rotate([180,0,270])  // top face
            linear_extrude(2,scale=0.5) square(4);
        translate([2,2,-1]) rotate([0,0,180])          // bottom face
            linear_extrude(2,scale=0.5) square(4);
    }
}

// This makes a chamfer path tracing the outline of the block
module chamfer_path() {
    chamfer();
    rotate([0,0,90]) chamfer();
    translate([0,30,0]) chamfer(12);
    translate([11,20,0]) chamfer(11);
    translate([21,10,0]) chamfer(11);
    translate([30,0,0]) rotate([0,0,90]) chamfer(12);
    translate([20,11,0]) rotate([0,0,90]) chamfer(11);
    translate([10,21,0]) rotate([0,0,90]) chamfer(11);
}

difference() {
    // Start with a block
    block();
    // Then make all the chamfer cuts
    chamfer_path();                           // bottom
    translate([0,0,height]) chamfer_path();   // top
    // Sides
    v_chamfer();
    translate([30, 0,0]) v_chamfer();
    translate([30,10,0]) v_chamfer();
    translate([20,20,0]) v_chamfer();
    translate([10,30,0]) v_chamfer();
    translate([ 0,30,0]) v_chamfer();
    // Cuts to clean up concave corners on top and bottom faces
    translate([20,10,0]) inside_corner_wedges(height);
    translate([10,20,0]) inside_corner_wedges(height);
}
