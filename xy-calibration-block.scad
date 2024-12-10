// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: Copyright 2024 Sam Blenny
//
// This is a test block to calibrate X-Y hole/contour compensation.

height = 5;

module stairstep_block() {
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

// This makes a tool shape to cut a hole with chamfered edges
module hole(height, diameter) {
    h = height;
    r = diameter / 2;
    rotate_extrude($fn=40)
    polygon([
        [0, -1], [r+2, -1], [r, 1], [r, h-1], [r+2, h+1], [0, h+1] 
    ]);
}

// This makes a stairstep shaped block having surfaces to measure 10,
// 20, and 30 mm distances in the X and Y directions, plus 3, 5, and
// 10 mm holes. This is meant to help set XY Contour Compensation and
// X-Y Hole Compensation calibration values in Bambu Studio, Cura, or
// other similar slicer software.
//
// To have OpenSCAD's preview mode show the shapes used to make the
// chamfer cuts, you can put a '#' or a '%' character at the start of
// the line for a cut. For example, you chould change `v_chamfer();`
// to `#v_chamfer();`
//
difference() {
    // Start with a block that has sharp corners
    stairstep_block();
    // Make chamfer cuts...
    // cut around the top and bottom perimeters
    translate([0,0,height]) chamfer_path();
    chamfer_path();
    // cut off the vertical outside corners
    v_chamfer();
    translate([30, 0,0]) v_chamfer();
    translate([30,10,0]) v_chamfer();
    translate([20,20,0]) v_chamfer();
    translate([10,30,0]) v_chamfer();
    translate([ 0,30,0]) v_chamfer();
    // remove sharp points at top and bottom of inside corners
    translate([20,10,0]) inside_corner_wedges(height);
    translate([10,20,0]) inside_corner_wedges(height);
    // cut chamfered holes
    translate([10, 10, 0]) hole(height, diameter=10);
    translate([22, 5, 0]) hole(height, diameter=5);
    translate([5, 22, 0]) hole(height, diameter=3);
}